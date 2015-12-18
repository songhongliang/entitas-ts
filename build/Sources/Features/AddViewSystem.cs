using Entitas;
using System.Collections.Generic;
public class AddViewSystem : ISetPool {

    Pool _pool;
    Group _group;

    public void SetPool(Pool pool) {
        _pool = pool;
        _group = pool.GetGroup(Matcher.AllOf(Matcher.Component));
    }

}