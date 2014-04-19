package cookix.core.services.context;

/**
 * Context's service - Various informations through the request
 * @author Axel Anceau (Peekmo)
 */
@:Service('cookix.context')
@:Parameters('%general.env%')
class Context 
{
    /**
     * @var environment: String Current environment (debug, prod)
     */
    public var environment(default, null): String;

    /**
     * @var request Current request
     */
    public var request(default, default): Dynamic;

    /**
     * Constructor - Sets the environment
     * @param  environment: String        Current environment (debug, prod)
     */
    public function new(environment: String)
    {
        this.environment = environment;
    }
}