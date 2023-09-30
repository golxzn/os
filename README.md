<h1 align="center">golxzn module public template</h1>

This repository is a template for make your own modules, which is compatible with
[golxzn/modules-cmake](golxzn/modules-cmake.link) system.

## __*Implementing your module*__

Actually, you don't really need to change something here. Just add your static libraries using
git submodule or just like subdirectories:

```shell
git submodule add <your repo with CMakeLists.txt> <your repo name>
```

Then, you need to change `${GXZN_NAME}_submodules` list to add your repo which you have just added:

```cmake
set(${GXZN_NAME}_submodules
	<your repo name>
)
```

If you want to fetch you repositories, change `GXZN_GIT_URL` variable, which is near `${GXZN_NAME}_submodules` list:

```cmake
set(GXZN_GIT_URL https://github.com/<YOUR_USERNAME>)
```

> Notice that your repository has to have special name: `<MODULE>-<SUBMODULE>`, where `<MODULE>` is the name of this repository, and `<SUBMODULE>` is the name of your submodule.



[golxzn/modules-cmake.link]: https://github.com/golxzn/modules-cmake