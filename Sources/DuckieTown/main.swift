import Apodini
import ApodiniREST

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
    }

    var content: some Component {
        Greeter()
    }
}

try DuckieTownWeb.main()
