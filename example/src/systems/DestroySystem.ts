module example {

  import IComponent = entitas.IComponent;
  import IReactiveSystem = entitas.IReactiveSystem;
  import ISetPool = entitas.ISetPool;
  import TriggerOnEvent = entitas.TriggerOnEvent;
  import Pool = entitas.Pool;
  import Entity = entitas.Entity;
  import CoreMatcher = entitas.CoreMatcher;

  export class DestroySystem implements IReactiveSystem, ISetPool {

    public get trigger():TriggerOnEvent {
      return CoreMatcher.Destroy.onEntityAdded();
    }

    _pool:Pool;

    public setPool(pool:Pool) {
      this._pool = pool;
    }

    public execute(entities:Array<Entity>) {
      //console.log('DestroySystem::execute', entities);
      for (var i=0, l=entities.length; i<l; i++) {
        console.log('destroy', entities[i]);
        this._pool.destroyEntity(entities[i]);
      }
    }
  }
}
