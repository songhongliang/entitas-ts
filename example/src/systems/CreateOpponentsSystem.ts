﻿module example {

  import IInitializeSystem = entitas.IInitializeSystem;
  import Pool = entitas.Pool;
  import ISetPool = entitas.ISetPool;

  export class CreateOpponentsSystem implements IInitializeSystem, ISetPool {
    _pool:Pool;

    public setPool(pool:Pool) {
      this._pool = pool;
    }

    public initialize() {
      const resourceName = "Opponent";
      for (var i = 1; i < 10; i++) {
        var speed = (Math.random()+.5) * 2;
        this._pool.createEntity()
          .addResource(resourceName)
          .addPosition(i*100 + 100, 0, 0)
          .addMove(speed, speed);
      }
    }
  }

}