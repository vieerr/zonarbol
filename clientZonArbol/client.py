from zeep import Client, Settings
from zeep.exceptions import Fault
from datetime import datetime
from tabulate import tabulate

WSDL_URL = 'http://localhost:8080/zonarbol/TreeService?wsdl'

# Configuración del cliente
settings = Settings(strict=False, xml_huge_tree=True)
client = Client(wsdl=WSDL_URL, settings=settings)

def mostrar_especies(especies):
    if not especies:
        print("No se encontraron especies.")
        return

    headers = ["ID", "Nombre científico", "Nombre común", "Familia", "Promedio de vida", "Estado conservación"]
    tabla = [
        [
            getattr(e, 'speciesId', ''),
            getattr(e, 'scientificName', ''),
            getattr(e, 'commonName', ''),
            getattr(e, 'family', ''),
            getattr(e, 'averageLifespan', '') if getattr(e, 'averageLifespan', None) is not None else '',
            getattr(e, 'conservationStatus', '') if getattr(e, 'conservationStatus', None) else ''
        ]
        for e in especies
    ]
    print(tabulate(tabla, headers=headers, tablefmt="grid"))

def agregar_especie():
    print("\n--- Agregar nueva especie ---")
    try:
        scientific_name = input("Nombre científico: ")
        common_name = input("Nombre común: ")
        family = input("Familia: ")

        lifespan_input = input("Promedio de vida (años, opcional): ")
        average_lifespan = int(lifespan_input) if lifespan_input.strip().isdigit() else None

        conservation_status = input("Estado de conservación (opcional): ")
        conservation_status = conservation_status.strip() if conservation_status.strip() else None

        tree_species_type = client.get_type('ns0:treeSpecies')

        nueva_especie = tree_species_type(
            speciesId=0,
            scientificName=scientific_name,
            commonName=common_name,
            family=family,
            averageLifespan=average_lifespan,
            conservationStatus=conservation_status
        )

        success = client.service.addTreeSpecies(nueva_especie)
        print("Especie agregada correctamente." if success else "No se pudo agregar la especie.")

    except Fault as e:
        print(f" Error SOAP: {e}")
    except Exception as ex:
        print(f" Error inesperado: {ex}")

def actualizar_especie():
    print("\n--- Actualizar especie ---")
    try:
        species_id_input = input("ID de la especie a actualizar: ")
        if not species_id_input.isdigit():
            print("ID inválido. Debe ser un número.")
            return
        species_id = int(species_id_input)

        # Obtener la especie actual
        especie_actual = client.service.getTreeSpeciesById(species_id)
        if not especie_actual:
            print(f"No se encontró especie con ID {species_id}")
            return

        print("Valores actuales (deje vacío para mantener):")

        scientific_name = input(f"Nombre científico [{especie_actual.scientificName}]: ") or especie_actual.scientificName
        common_name = input(f"Nombre común [{especie_actual.commonName}]: ") or especie_actual.commonName
        family = input(f"Familia [{especie_actual.family}]: ") or especie_actual.family

        lifespan_current = especie_actual.averageLifespan
        lifespan_input = input(f"Promedio de vida [{lifespan_current if lifespan_current is not None else ''}]: ")
        if lifespan_input.strip() == '':
            average_lifespan = lifespan_current
        elif lifespan_input.strip().isdigit():
            average_lifespan = int(lifespan_input.strip())
        else:
            print("Valor inválido para promedio de vida, se mantendrá el actual.")
            average_lifespan = lifespan_current

        conservation_current = especie_actual.conservationStatus if especie_actual.conservationStatus else ''
        conservation_status = input(f"Estado de conservación [{conservation_current}]: ")
        conservation_status = conservation_status.strip() if conservation_status.strip() else conservation_current

        tree_species_type = client.get_type('ns0:treeSpecies')

        especie_actualizada = tree_species_type(
            speciesId=species_id,
            scientificName=scientific_name,
            commonName=common_name,
            family=family,
            averageLifespan=average_lifespan,
            conservationStatus=conservation_status
        )

        success = client.service.updateTreeSpecies(especie_actualizada)
        print("Especie actualizada correctamente." if success else "No se pudo actualizar la especie.")

    except Fault as e:
        print(f"Error SOAP: {e}")
    except Exception as ex:
        print(f"Error inesperado: {ex}")

def eliminar_especie():
    print("\n--- Eliminar especie ---")
    try:
        species_id = int(input("ID de la especie a eliminar: "))
        confirm = input(f"¿Está seguro de eliminar la especie con ID {species_id}? (s/n): ")
        if confirm.lower() != 's':
            print("Eliminación cancelada.")
            return

        success = client.service.deleteTreeSpecies(species_id)
        print("Especie eliminada correctamente." if success else "No se pudo eliminar la especie.")
    except Fault as e:
        print(f"Error SOAP: {e}")
    except Exception as ex:
        print(f"Error inesperado: {ex}")

def menu():
    while True:
        print("\n===== MENÚ DE OPCIONES =====")
        print("1. Ver todas las especies")
        print("2. Buscar especie por ID")
        print("3. Buscar especies por nombre")
        print("4. Ver cantidad total de especies")
        print("5. Agregar nueva especie")
        print("6. Actualizar especie existente")
        print("7. Eliminar especie")
        print("8. Salir")
        opcion = input("Selecciona una opción: ")

        try:
            if opcion == "1":
                especies = client.service.getAllTreeSpecies()
                mostrar_especies(especies)

            elif opcion == "2":
                species_id = int(input("Ingrese el ID de la especie: "))
                especie = client.service.getTreeSpeciesById(species_id)
                mostrar_especies([especie] if especie else [])

            elif opcion == "3":
                query = input("Ingrese texto a buscar: ")
                especies = client.service.searchTreeSpecies(query)
                mostrar_especies(especies)

            elif opcion == "4":
                cantidad = client.service.getTreeSpeciesCount()
                print(f"Total de especies: {cantidad}")

            elif opcion == "5":
                agregar_especie()

            elif opcion == "6":
                actualizar_especie()

            elif opcion == "7":
                eliminar_especie()

            elif opcion == "8":
                print("Saliendo... uwu")
                break

            else:
                print("Opción no válida. Por favor, elija del 1 al 8.")

        except Fault as e:
            print(f"Error en el servicio: {e}")
        except Exception as ex:
            print(f"Error inesperado: {ex}")

if __name__ == "__main__":
    menu()
