import Apodini
import ApodiniREST
import ApodiniOpenAPI


struct Greeter: Handler {
    @Parameter var country: String?

    func handle() -> String {
        "Hello, \(country ?? "World")!"
    }
}

struct DuckieTownWeb: WebService {
    var configuration: Configuration {
        ExporterConfiguration()
            .exporter(RESTInterfaceExporter.self)
            .exporter(OpenAPIInterfaceExporter.self)
        
        DuckieTownConfiguration(logLevel: .info)
    }
    
    @PathParameter(identifying: DuckieBot.self) var botId: String

    var content: some Component {
        Greeter()
        Group{
            "instruction"
            $botId
        } content: {
            DuckiebotGetInstructionHandler(botId: $botId)
                .operation(.read)
            DuckiebotAddInstructionHandler(botId: $botId)
                .operation(.create)
        }
    }
}

var duckiebot: DuckieBot = DuckieBot(id: "0", intersectionId: 0, atDirection: .south)

try DuckieTownWeb.main()
