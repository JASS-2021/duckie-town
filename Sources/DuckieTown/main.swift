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
    @PathParameter(identifying: DuckieBot.self) var botId: String
    
    var content: some Component {
        Greeter()
        Group("duckiebot") {
            AddDuckiebotHandler()
                .operation(.create)
            GetAllDuckiebotsHandler()
                .operation(.read)
            Group{
                $botId
                "position"
            } content: {
                DuckiebotGetPositionHandler(botId: $botId)
                    .operation(.read)
                DuckiebotSetPositionHandler(botId: $botId)
                    .operation(.update)
            }
        }
        Group{
            "instruction"
            $botId
        } content: {
            DuckiebotGetInstructionHandler(botId: $botId)
                .operation(.read)
            DuckiebotAddInstructionHandler(botId: $botId)
                .operation(.create)
        }
        Group("intersection") {
            GetIntersectionHandler()
                .operation(.read)
            GetIntersectionsHandler()
                .operation(.read)
            SetIntersectionsHandler()
                .operation(.update)
        }
    }
    
    var configuration: Configuration {
        ExporterConfiguration()
            .exporter(RESTInterfaceExporter.self)
            .exporter(OpenAPIInterfaceExporter.self)
        
        DuckieTownConfiguration(logLevel: .info)
    }
}

try DuckieTownWeb.main()
