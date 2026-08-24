# Setting up new project
- Create the project's folder and cd to it
- Run:
```
npm init -y
npm install --save-dev typescript @types/node tsx
npx tsc --init
```

# Compiling
- Make sure rootdir and outdir are not commented in tsconfig.json 
- To compile run:
```
tsc
```
- The comiled js files will be stored in the outdir
- Run the compiled js using:
```
node [JS-FILE-PATH]
```
