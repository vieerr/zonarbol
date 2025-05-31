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
        <form action="auth" method="post" class="form-control space-y-4">
            <input type="hidden" name="action" value="login">
            <label class="label">
                <span class="label-text font-bold">Usuario</span>
            </label>
            <input type="text" name="username" placeholder="nombre usuario" class="input input-bordered" required />

            <label class="label">
                <span class="label-text font-bold">Contraseña</span>
            </label>
            <input type="password" name="password" placeholder="contraseña" class="input input-bordered" required />
            <button type="submit" class="btn btn-success mt-4">Ingresar</button>
            <% 
                String error = request.getParameter("error");
                if ("1".equals(error)) {
            %>
                <div id="err-msg" class="flex items-start p-4 rounded-md mb-6 relative bg-[rgba(230,57,70,0.1)] border-l-4 border-[#e63946] text-[#e63946]">
                    <svg class="w-5 h-5 mr-3 shrink-0" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                    </svg>
                    <div class="flex-grow text-[0.95rem]">
                        <p><strong class="font-semibold">¡Error!</strong> Usuario o contraseña incorrectos.</p>
                    </div>
                </div>
            <% 
                } 
            %>
        </form>
    </div>
    <script src="scripts/login_script.js"></script>    
</body>
</html>
