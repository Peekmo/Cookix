package src.core.request;

/**
 * Interface to implements to create a Request object for an other language
 * @author Axel Anceau (Peekmo)
 */
interface RequestInterface
{
    public function build() : RequestInterface;
}