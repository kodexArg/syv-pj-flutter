# Arquitectura — syv-pj-flutter

> Estado actual: **Etapa 1**. Esta doc describe lo que existe hoy y señala
> las costuras donde crecerá la app en etapas siguientes.

---

## Descripción general

`syv-pj-flutter` es una aplicación Flutter de escritorio Linux. Es una capa
de presentación pura: no tiene backend propio ni lógica de dominio. Todo dato
que muestra viene de `syv-pj-api`; toda decisión sobre qué es un personaje
vive en `syv-pj/`.

---

## Gestión del SDK (FVM)

El SDK de Flutter está **contenido vía FVM 4.1.1**. La versión exacta
(`3.44.2 stable`) está pinneada en `.fvmrc`. Esto garantiza que todos los
agentes y desarrolladores usen exactamente el mismo SDK sin depender del
Flutter instalado globalmente en el sistema.

Regla permanente: siempre `fvm flutter <comando>`, nunca `flutter` suelto.

---

## Target: Linux desktop

La única plataforma activa es Linux desktop (GNOME/Wayland, máquina Ryzen +
RTX 2060 SUPER). La ventana se configura con `window_manager` 0.5.1:

- Tamaño fijo: 390×844 (phone-portrait flotante)
- Sin decoración de ventana (`titleBarStyle: TitleBarStyle.hidden`)
- No redimensionable

La elección de phone-portrait en desktop es intencional: el visualizador está
pensado para comportarse como una "ficha móvil" en pantalla, coherente con la
estética del universo SyV.

---

## Layout de `lib/`

```
lib/
  main.dart               # Punto de entrada. Inicializa WidgetsFlutterBinding,
                          # configura la ventana y llama a runApp(const App()).
  app/
    app.dart              # MaterialApp raíz. Define tema base y ruta inicial.
    window_config.dart    # Toda la configuración de window_manager en un lugar.
                          # Costura futura: aquí se puede añadir soporte
                          # multi-ventana o resizing controlado.
  features/
    home/
      home_view.dart      # Vista de Etapa 1: "Hola, mundo!" + botón Cerrar.
                          # Costura futura: se reemplaza por la vista de ficha
                          # de personaje cuando arranque Etapa 3.
```

La separación por `features/` es deliberada: cada feature futura (detalle de
personaje, lista, navegación) tendrá su propia carpeta sin tocar las demás.

---

## Costuras para etapas futuras

| Costura | Dónde | Etapa |
|---|---|---|
| Cliente HTTP para `syv-pj-api` | `lib/app/` o `lib/core/` nuevo | Etapa 2-3 |
| Tokens de `syv-design-system` | `lib/app/app.dart` (tema) | Etapa 3 |
| Navegación entre vistas | `lib/app/app.dart` (router) | Etapa 3 |
| Harness Python (uv) | Fuera de `lib/`, script separado | Etapa 2 |

---

## Dependencias activas

| Paquete | Versión | Propósito |
|---|---|---|
| `window_manager` | 0.5.1 | Control de ventana nativa Linux |
| `cupertino_icons` | ^1.0.8 | Íconos (soporte multiplataforma futuro) |
| `flutter_lints` | ^6.0.0 | Lint recomendado |

No hay dependencias de red, estado global ni UI component libraries todavía.
La mínima superficie de dependencias es intencional en Etapa 1.
