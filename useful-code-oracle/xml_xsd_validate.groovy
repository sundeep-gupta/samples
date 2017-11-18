import javax.xml.XMLConstants
import javax.xml.transform.stream.StreamSource
import javax.xml.validation.SchemaFactory

xsdUrl = 'file:///scratch/skgupta/git_storage/emdi/xsd.xsd'
xmlUrl = 'file:///scratch/skgupta/git_storage/emdi/xml.xml'

new URL( xsdUrl ).withInputStream { xsd ->
  new URL( xmlUrl ).withInputStream { xml ->
      SchemaFactory.newInstance( XMLConstants.W3C_XML_SCHEMA_NS_URI )
              .newSchema( new StreamSource( xsd ) )
                    .newValidator()
                    .validate( new StreamSource( xml ) )
    }
}
