Репозиторий с моими конфигами

# Автоконфигурация девконтейнера


Чтобы сконфигурировать любой девконтейнер в devcontainer.json прописываем строку
```json
{
  "postCreateCommand": "bash -c 'curl -fsSL https://raw.githubusercontent.com/settlermine/config/master/scripts/configure-devcontainer.sh | bash'"
}
```
Она установит подцепит скрипт и установит neovim с необходимым конфигом

