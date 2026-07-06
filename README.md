# syv-pj-flutter

Visualizador de personajes del universo *Subordinación y Valor* (SyV).
App Flutter de escritorio Linux — Etapa 1 completada.

> Lee primero: [AGENTS.md](AGENTS.md) (contexto del proyecto) y [PRD.md](PRD.md) (hoja de ruta).

---

## Quick start

Requisito previo: [FVM](https://fvm.app/) instalado (`fvm --version` → 4.1.1).

```bash
# 1. Instalar el SDK de Flutter pinneado
cd /home/kodex/SyV/syv-pj-flutter
fvm install

# 2. Obtener dependencias
fvm flutter pub get

# 3. Correr en Linux desktop
fvm flutter run -d linux
```

La ventana arranca en 390×844 (phone-portrait), borderless. Muestra
"Hola, mundo!" y un botón "Cerrar" que termina la app.

---

## Stack

| Componente | Versión |
|---|---|
| Flutter | 3.44.2 (stable) |
| Dart | 3.12.2 |
| FVM | 4.1.1 |
| Target | Linux desktop (GNOME/Wayland) |

---

## Estructura

```
lib/
  main.dart                  # Entrada: inicializa ventana y corre la app
  app/
    app.dart                 # MaterialApp raíz
    window_config.dart       # Configuración de window_manager
  features/
    home/
      home_view.dart         # Vista principal (Etapa 1)
docs/
  architecture.md            # Arquitectura actual y costuras futuras
  adrs/                      # Registro de decisiones (vacío hasta el primer ADR)
```

---

## Tests

```bash
# Tests unitarios y de widget
fvm flutter test

# Tests de integración
fvm flutter test integration_test/
```

---

## Ecosistema SyV

Este repo es parte de un ecosistema más amplio. Ver
[`../CLAUDE.md`](../CLAUDE.md) para el mapa completo.
