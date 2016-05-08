package {{ namespace }} 
/**
 * Entitas Generated Components and Extensions for {{ namespace }}
 *
 * do not edit this file
 */
 
import java.util.*
import com.darkoverlordofdata.entitas.IComponent
import com.darkoverlordofdata.entitas.IMatcher
import com.darkoverlordofdata.entitas.Matcher
import com.darkoverlordofdata.entitas.Entity


/**
 * Components
 */
enum class Component {
{% for component in components %}    {{ component.key }},
{% endfor %}    TotalComponents
}
{% for component in components %}
{% if component.value == false %}data class {{ component.key }}Component(var active:Boolean=true) : IComponent 
{% else %}data class {{ component.key }}Component({% for field in component.value %}var {{ field }} = {{ field | defaultValue }}{% if forloop.index <  forloop.length %},{% endif %}{% endfor %}) : IComponent 
{% endif %}{% endfor %}

/**
 * Matcher extensions
 */
{% for component in components %}
val Matcher.static.{{ component.key }}:IMatcher get() = Matcher.static.allOf(Component.{{ component.key }}.ordinal) 
{% endfor %}

/**
 * Entity extensions
 */
{% for component in components %}
/** Entity: {{ component.key }} methods*/
{% if component.value == false %}

val Entity_{{ component.key | camel }}Component =  {{ component.key }}Component()

var Entity.is{{ component.key }}:Boolean
    get() = hasComponent(Component.{{ component.key }}.ordinal)
    set(value) {
        if (value != is{{ component.key }})
            addComponent(Component.{{ component.key }}.ordinal, Entity_{{ component.key | camel }}Component)
        else
            removeComponent(Component.{{ component.key }}.ordinal)
    }

fun Entity.set{{ component.key }}(value:Boolean):Entity {
    is{{ component.key }} = value
    return this
}

{% else %}

val Entity_{{ component.key | camel }}ComponentPool:MutableList<{{ component.key }}Component> = ArrayList(listOf())

val Entity.{{ component.key | camel }}:{{ component.key }}Component
    get() = getComponent(Component.{{ component.key }}.ordinal) as {{ component.key }}Component

val Entity.has{{ component.key }}:Boolean
    get() = hasComponent(Component.{{ component.key }}.ordinal)

fun Entity.clear{{ component.key }}ComponentPool() {
    Entity_{{ component.key | camel }}ComponentPool.clear()
}

fun Entity.add{{ component.key }}({{ component.value | params }}):Entity {
    val component = if (Entity_{{ component.key | camel }}ComponentPool.size > 0) Entity_{{ component.key | camel }}ComponentPool.last() else {{ component.key }}Component()
    {% for field in component.value %}component.{{ field | property }} = {{ field | property }}
    {% endfor %}
    addComponent(Component.{{ component.key }}.ordinal, component)
    return this
}

fun Entity.replace{{ component.key }}({{ component.value | params }}):Entity {
    val previousComponent = if (has{{ component.key }}) {{ component.key | camel }} else null
    val component = if (Entity_{{ component.key | camel }}ComponentPool.size > 0) Entity_{{ component.key | camel }}ComponentPool.last() else {{ component.key }}Component()
    {% for field in component.value %}component.{{ field | property }} = {{ field | property }}
    {% endfor %}
    replaceComponent(Component.{{ component.key }}.ordinal, component)
    if (previousComponent != null)
        Entity_{{ component.key | camel }}ComponentPool.add(previousComponent)
    return this
}

fun Entity.remove{{ component.key }}():Entity {
    val component = {{ component.key | camel }}
    removeComponent(Component.{{ component.key }}.ordinal)
    Entity_{{ component.key | camel }}ComponentPool.add(component)
    return this
}


{% endif %}
{% endfor %}