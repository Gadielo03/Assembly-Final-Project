# Assembly-Final-Project
Version del proyecto con textos en español para presentarlo

Para construir y ejectura:

```
masm main;
masm anim;
masm flor;
masm control;
masm libg;
masm libutil;

lib milib +flor +control;

link main anim, final,,milib;

final.exe
```