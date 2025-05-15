<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ingreso - Sistema de Registro Forestal</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
</head>
<body class="min-h-screen bg-gradient-to-br from-green-100 to-green-300 flex items-center justify-center">
    <div class="card w-full max-w-sm shadow-2xl bg-base-100 p-6">
        <h2 class="text-2xl font-bold text-center mb-4">🌲 ZonArbol</h2>
        <form action="login" method="post" class="form-control space-y-4">
            <label class="label">
                <span class="label-text">Usuario</span>
            </label>
            <input type="text" name="username" placeholder="admin" class="input input-bordered" required />

            <label class="label">
                <span class="label-text">Contraseña</span>
            </label>
            <input type="password" name="password" placeholder="admin" class="input input-bordered" required />

            <button type="submit" class="btn btn-success mt-4">Ingresar</button>
        </form>

        <p class="text-sm text-center text-gray-500 mt-4">
            Usuario: <strong>admin</strong> &nbsp;&nbsp; Contraseña: <strong>admin</strong>
        </p>
    </div>
</body>
</html>
