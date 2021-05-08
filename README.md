<p align="center">
  <h3 align="center">Time is Money</h3>
  <p align="center">
    <img src="./android/app/src/main/ic_launcher-playstore.png" width="100">
  </p>

  <p align="center">
    Trabalho de conclusão do curso de Flutter
    <br>
    <br>
    FIAP - MBA - MOBILE DEVELOPMENT
    <br>
    APPS, IOT, CHATBOTS & VIRTUAL ASSISTANTS
    <br>
  </p>
</p>

## Integrantes
- [Helton Isac](https://github.com/helton-isac)
- [Helton Souza](https://github.com/heltonss)
- [Lyan Masterson](https://github.com/lyanmaster)
- [Ricardo Kerr](https://github.com/RicardoKerr)

## Professor
- [Ricardo Ogliari](https://gist.github.com/ricardoogliari)

## Video demonstrativo:

<p align="center">
<a href="http://www.youtube.com/watch?feature=player_embedded&v=mkOcbPzWBtI
" target="_blank"><img src="https://img.youtube.com/vi/mkOcbPzWBtI/0.jpg" 
alt="IMAGE ALT TEXT HERE" /></a>
</p>

## Sobre o Trabalho:

Criamos um aplicativo capaz de marcar e sumarizar periodos de tempos, como um relógio de ponto, onde você marca a entrada e saida.

No trabalho focamos apenas na plataforma Android.

O Aplicativo possui as seguintes telas:
- Splash Screen
- Login
- Criação de usuário
- Home
- About
- Apontar Horas
- Histórico
    - Lista Mensal
    - Lista Diaria

## Tecnologias:

As seguintes tecnologias e bibliotecas foram utilizadas:
- Flutter
- Firebase
    - Authentication - firebase_auth: ^1.1.1
    - Firestore - cloud_firestore: "^1.0.5"
    - Crashlytics - Native
- shared_preferences: ^2.0.5
- email_validator: '^1.0.6'
- vibration: ^1.7.3
- intl: ^0.17.0
- SimpleBiometricAPI: 1.0.3
- conventional_commit: ^0.3.0+1

O Login e criação de usuário utilizam o Firebase Auth

A leitura biometrica foi feita utilizando uma lib nativa criada para outro projeto academico pelo mesmo grupo: [SimpleBiometricAPI](https://jitpack.io/#helton-isac/SimpleBiometricAPI). Como ela não possui suporte para Flutter, utilizamos platform channel para disponibilizar a api na camada dart. 

Também utilizamos Shared Preferences para saber quando o usuário optou por utilizar leitura biometrica ou não.

EmailValidator foi utilizado para validar o e-mail durante a criação do usuario.

As telas de Marcação de ponto e histórico utilizam o Firestore para armazenar e apresentar os registros feito pelo usuário.

A api de vibration foi utilizada para dar um feedback ao usuário quando o ponto é registrado

O Crashlytics foi utilizado para monitoração.


