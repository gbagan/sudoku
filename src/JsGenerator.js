export const toLazyListImpl = defer => nil => cons => generator => {
    const gen = generator()
    const defered = () => defer(() => {
        const { value, done } = gen.next()
        if (done)
            return nil
        else
            return cons(value)(defered())
    })
    return defered()
}
