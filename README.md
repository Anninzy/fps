# TODO

- [ ] Gotta do some more clean up on codes, organise them into folders as well
    - [ ] Prevent duplicate function / variable / module name, e.g. RaycastBullet
    - [ ] Rename things accordingly, might not be accurate to the definition of the terms, but makes a good enough distinction
        - Client: Controller
        - Server: Manager
        - Shared: Service
- [ ] Wallbang
- [ ] Gun muzzle
- [ ] Bullet tracer
- [ ] GunManager: Implement shield
- [ ] RecoilController: Implement recoil for guns without spray
- [ ] GunManager: Utilise parallel Lua
- [ ] Set repo to public after getting the project to a playable state

# BUILD

```bash
aftman install
wally install
rojo build -o "{project_name}.rbxlx"
```

# NOTES
This repo does not contain the place file, so errors are expected due to missing models.

---

Built with partially managed Rojo
