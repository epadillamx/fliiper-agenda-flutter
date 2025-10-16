<div align="center">
  <img src="lib/presentation/assets/logo.svg" alt="FliiperReserver Logo" width="200"/>
  
  # FliiperReserver
  
  **Sistema de Reservas Inteligente**
  
  Una aplicación Flutter moderna construida con arquitectura hexagonal para gestionar reservas de manera eficiente.
  
  ![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
  ![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
  ![Architecture](https://img.shields.io/badge/Architecture-Hexagonal-FF0083)
</div>

---

## 📋 Tabla de Contenidos

- [Sobre el Proyecto](#sobre-el-proyecto)
- [Arquitectura](#arquitectura)
- [Estructura de Carpetas](#estructura-de-carpetas)
- [Instalación](#instalación)
- [Uso](#uso)

---

## 🎯 Sobre el Proyecto

FliiperReserver es una aplicación de gestión de reservas desarrollada en Flutter que implementa principios de arquitectura hexagonal (puertos y adaptadores). Esta arquitectura garantiza:

- **Separación de responsabilidades**: Cada capa tiene un propósito específico
- **Testabilidad**: El código de negocio es independiente de frameworks
- **Mantenibilidad**: Cambios en una capa no afectan a las demás
- **Escalabilidad**: Fácil agregar nuevas funcionalidades

---

## 🏗️ Arquitectura

Este proyecto sigue la **Arquitectura Hexagonal** (también conocida como Arquitectura de Puertos y Adaptadores), que organiza el código en capas concéntricas:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │  ← UI, Widgets, Pages
├─────────────────────────────────────────┤
│        Application Layer                │  ← Services, Coordinadores
├─────────────────────────────────────────┤
│          Domain Layer                   │  ← Lógica de Negocio (Core)
│   (Entities, Use Cases, Repositories)   │
├─────────────────────────────────────────┤
│       Infrastructure Layer              │  ← Implementaciones concretas
│    (APIs, Database, External Services)  │
└─────────────────────────────────────────┘
```

### Principios Clave

1. **Domain (Núcleo)**: No depende de nada externo
2. **Application**: Orquesta el dominio
3. **Infrastructure**: Implementa adaptadores externos
4. **Presentation**: Interfaz de usuario

---

## 📁 Estructura de Carpetas

```
lib/
├── application/              # Capa de Aplicación
│   ├── [context]/            # Organizado por contexto de negocio (Screaming)
│   │   └── [feature]/        # Organizado por característica
│   │       └── services/     # Servicios de aplicación que coordinan casos de uso
│   ├── auth/                 # Ejemplo: servicios de autenticación
│   │   └── login/            # Ejemplo: servicios de login
│   │       └── services/     # Servicios de aplicación que coordinan casos de uso, como LoginService
│
├── core/                    # Utilidades compartidas
│   └── theme/              # Configuración de tema y colores
│       ├── app_colors.dart # Paleta de colores de la aplicación
│       └── app_theme.dart  # Configuración del tema global
│
├── domain/                  # Capa de Dominio (Lógica de Negocio)
│   └── [context]/          # Organizado por contexto de negocio (Screaming)
│       └── [feature]/      # Organizado por característica
│           ├── entities/   # Entidades del dominio
│           ├── repositories/ # Interfaces de repositorios (contratos)
│           └── usecases/   # Casos de uso (lógica de negocio)
│       └── auth/           # Ejemplo: contexto de autenticación
│           └── login/      # Ejemplo: característica de login
│               ├── entities/
│               ├── repositories/
│               └── usecases/
│
├── infrastructure/          # Capa de Infraestructura
│   └── [context]/          # Organizado por contexto (Screaming)
│       └── [feature]/      # Organizado por característica
│           ├── adapters/   # Implementaciones concretas de repositorios
│           └── models/     # Modelos de datos (DTOs, respuestas de API)
│       └── auth/           # Ejemplo: infraestructura de autenticación
│           └── login/      # Ejemplo: implementación de login
│               ├── adapters/
│               └── models/
│
├── presentation/            # Capa de Presentación
│   ├── assets/             # Recursos estáticos (imágenes, logos, iconos)
│   ├── controllers/        # Controladores de estado (Provider, Bloc, etc.)
│   ├── pages/              # Páginas/Pantallas organizadas por contexto
│   │   └── [context]/     # Organizado por contexto (Screaming)
│   │       └── [feature]/ # Organizado por característica
│   │   └── auth/          # Ejemplo: páginas de autenticación
│   │       └── login/     # Ejemplo: página de login
│   ├── shared/             # Componentes compartidos entre módulos
│   └── widgets/            # Widgets reutilizables
│
└── main.dart               # Punto de entrada de la aplicación
```

### Descripción Detallada de Carpetas

#### 🎯 **`domain/`** - Capa de Dominio
El corazón de la aplicación. Contiene la lógica de negocio pura sin dependencias externas.

Organizado por **contextos de negocio** y luego por **características** (Screaming Architecture):
- **`[context]/[feature]/entities/`**: Modelos de dominio que representan conceptos del negocio
- **`[context]/[feature]/repositories/`**: Interfaces que definen contratos para acceder a datos
- **`[context]/[feature]/usecases/`**: Casos de uso que implementan reglas de negocio específicas

**Ejemplo**: `domain/auth/login/` contiene toda la lógica de negocio relacionada con el login.

#### 🔧 **`application/`** - Capa de Aplicación
Orquesta la lógica del dominio y coordina el flujo de datos.

Organizado por **contextos** y **características** (Screaming Architecture):
- **`[context]/[feature]/services/`**: Servicios que combinan múltiples casos de uso y coordinan operaciones complejas

**Ejemplo**: `application/auth/login/services/` contiene servicios que orquestan los casos de uso de login.

#### 🔌 **`infrastructure/`** - Capa de Infraestructura
Implementaciones concretas de adaptadores externos.

Organizado por **contextos** y **características** (Screaming Architecture):
- **`[context]/[feature]/adapters/`**: Implementaciones de repositorios que se conectan a APIs, bases de datos, etc.
- **`[context]/[feature]/models/`**: DTOs (Data Transfer Objects) y modelos específicos de la infraestructura

**Ejemplo**: `infrastructure/auth/login/` contiene las implementaciones concretas para el login.

#### 🎨 **`presentation/`** - Capa de Presentación
Todo lo relacionado con la interfaz de usuario.

Organizado por **contextos** y **características** (Screaming Architecture):
- **`assets/`**: Recursos estáticos como imágenes, logos SVG, iconos
- **`pages/[context]/[feature]/`**: Pantallas completas organizadas por contexto y característica
- **`widgets/`**: Componentes UI reutilizables
- **`shared/`**: Componentes compartidos entre múltiples módulos
- **`controllers/[context]/[feature]/`**: Gestión de estado (Provider, Bloc, Riverpod, etc.)

**Ejemplo**: `presentation/pages/auth/login/` contiene la interfaz de usuario del login.
**Ejemplo**: `presentation/controllers/auth/login/` contiene el controlador del login.

#### ⚙️ **`core/`** - Utilidades Compartidas
Código compartido entre todas las capas.

- **`theme/`**: Configuración de temas, colores y estilos globales

### Arquitectura Hexagonal + Screaming Architecture

El proyecto combina dos patrones arquitectónicos poderosos:

#### 🔷 **Arquitectura Hexagonal (Puertos y Adaptadores)**
Separa la aplicación en capas concéntricas donde el dominio es el núcleo independiente:
- **Domain**: Núcleo de negocio sin dependencias externas
- **Application**: Orquesta los casos de uso del dominio
- **Infrastructure**: Implementa adaptadores para servicios externos (APIs, BD)
- **Presentation**: Interfaz de usuario que consume la aplicación

#### 📢 **Screaming Architecture**
Organiza el código por **características de negocio** en lugar de por tipo técnico:
- Las carpetas "gritan" qué hace la aplicación (auth, reservations, payments)
- Cada característica contiene todas sus capas en su propio contexto
- Facilita encontrar y modificar código relacionado con una funcionalidad específica

#### 💡 **Ventajas de esta Combinación**

1. **Modularidad**: Cada característica es autocontenida y fácil de localizar
2. **Escalabilidad**: Agregar nuevas características no afecta las existentes
3. **Mantenibilidad**: Los cambios están aislados por contexto y característica
4. **Testabilidad**: El dominio es puro y las dependencias están invertidas
5. **Claridad**: La estructura "grita" la funcionalidad del sistema

#### 📝 **Ejemplo Práctico: Módulo de Login**

```
domain/auth/login/           → Lógica de negocio del login
├── entities/                → Entidad User
├── repositories/            → Contrato ILoginRepository
└── usecases/                → Caso de uso LoginUseCase

infrastructure/auth/login/   → Implementación técnica del login
├── adapters/                → LoginRepositoryImpl (llamadas HTTP)
└── models/                  → LoginRequestDTO, LoginResponseDTO

application/auth/login/services/  → Coordinación del login
└── login_service.dart       → Servicio que orquesta el flujo

presentation/pages/auth/login/ → UI del login
└── login_page.dart          → Pantalla de login
```

Este enfoque permite que todo el código relacionado con "login" esté organizado por capas pero agrupado conceptualmente, haciendo que la arquitectura "grite" que el sistema tiene funcionalidad de autenticación.

---

## 🚀 Instalación

### Requisitos Previos

- Flutter SDK 3.9.2 o superior
- Dart SDK 3.9.2 o superior

### Pasos

1. **Clonar el repositorio**

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

---

## 💻 Uso

### Ejecutar en modo desarrollo
```bash
flutter run
```

### Ejecutar tests
```bash
flutter test
```

### Generar build de producción
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🎨 Paleta de Colores

- **Primary**: `#FF0083` - Color principal de la marca
- **White**: `#FFFFFF` - Fondo y textos claros
- **Text Dark**: `#333333` - Textos principales
- **Text Light**: `#666666` - Textos secundarios
- **Error**: `#D32F2F` - Estados de error

---

## 📦 Dependencias Principales

- `flutter_svg: ^2.0.19` - Renderizado de imágenes SVG

---

<div align="center">
  Desarrollado con ❤️ usando Flutter
</div>
