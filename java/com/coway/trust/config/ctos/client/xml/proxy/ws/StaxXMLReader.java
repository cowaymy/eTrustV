package com.coway.trust.config.ctos.client.xml.proxy.ws;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import com.coway.trust.util.CommonUtils;

import javax.xml.namespace.QName;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.StartElement;
import javax.xml.stream.events.XMLEvent;
import java.io.ByteArrayInputStream;
import java.io.UnsupportedEncodingException;

public class StaxXMLReader {
    private static final String FICO_INDEX_ELEMENT = "fico_index";
    private static final String BANK_RUPTCY_ELEMENT = "bankruptcy";
    private static final String CONFIRM_ENTITY_ELEMENT = "confirm_entity";

    private static final String FICO_INDEX_SCORE = "score";
    private static final String BANK_RUPTCY_STATUS = "status";
    private static final String CONFIRM_ENTITY_STATUS = "confirmEntity";
// Experian Fields====================================================================
    private static final String EXPERIAN_REPOTYPE_ELEMENT = "product_code";
    private static final String EXPERIAN_TOKEN1_ELEMENT = "token1";
    private static final String EXPERIAN_TOKEN2_ELEMENT = "token2";
    private static final String ISCORE_ELEMENT = "i_score";
    private static final String RISK_ISCORE_ELEMENT = "risk_grade";
    private static final String BKR_COUNT = "bankruptcy_count";
//Experian =========================================================================

    public static int getFicoScore(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        String ficoScore = getValueByQName(xmlString, FICO_INDEX_ELEMENT, FICO_INDEX_SCORE);
        if (StringUtils.isEmpty(ficoScore)) {
            ficoScore = "0";
        }
        return Integer.parseInt(ficoScore);
    }

    public static String getBankruptcy(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        return getValueByQName(xmlString, BANK_RUPTCY_ELEMENT, BANK_RUPTCY_STATUS);
    }

    public static String getConfirmEntity(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        return getValueByQName(xmlString, CONFIRM_ENTITY_ELEMENT, CONFIRM_ENTITY_STATUS);
      }

//Experian =========================================================================================
    public static String getRptType(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        return getEValueByAttribute(xmlString, EXPERIAN_REPOTYPE_ELEMENT, "");
    }
    public static String getExperianTkn1(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        return getEValueByAttribute(xmlString,EXPERIAN_TOKEN1_ELEMENT, "");
    }
    public static String getExperianTkn2(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        return getEValueByAttribute(xmlString,EXPERIAN_TOKEN2_ELEMENT, "");
    }
    public static int getExperianiScore(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        String iScore = getEValueByAttribute(xmlString, ISCORE_ELEMENT, "");
        if (StringUtils.isEmpty(iScore)) {
            iScore = "0";
        }
        return Integer.parseInt(iScore);
    }
    public static int getExperianRisk(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        String RiskScore = getEValueByAttribute(xmlString, RISK_ISCORE_ELEMENT, "");
        if (StringUtils.isEmpty(RiskScore)) {
            RiskScore = "0";
        }
        return Integer.parseInt(RiskScore);
    }
    public static int getExperianBkrCnt(String xmlString) throws UnsupportedEncodingException, XMLStreamException {
        String bankRuptCount = getEValueByAttribute(xmlString, BKR_COUNT, "");
        if (StringUtils.isEmpty(bankRuptCount)) {
            bankRuptCount = "0";
        }
        return Integer.parseInt(bankRuptCount);
    }

    private static String getEValueByAttribute(String xmlString, String element, String qname) throws UnsupportedEncodingException, XMLStreamException {
        String value = "";
        byte[] byteArray = xmlString.getBytes("UTF-8");
        ByteArrayInputStream inputStream = new ByteArrayInputStream(byteArray);
        XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
        XMLEventReader xmlEventReader = xmlInputFactory.createXMLEventReader(inputStream);
        while (xmlEventReader.hasNext()) {
            XMLEvent xmlEvent = xmlEventReader.nextEvent();
            if (xmlEvent.isStartElement()) {
                StartElement startElement = xmlEvent.asStartElement();
                if (startElement.getName().getLocalPart().equals("i_score")){
                    xmlEvent = xmlEventReader.nextEvent();
                    if (xmlEvent.isStartElement()) {
                        startElement = xmlEvent.asStartElement();
                        if (startElement.getName().getLocalPart().equals(element)) {
                            xmlEvent = xmlEventReader.nextEvent();
                            if(xmlEvent.isEndElement()){
                                value = "0";
                            }else{
                                value = xmlEvent.toString();
                            }
                            break;
                        }
                    }
                }else if (startElement.getName().getLocalPart().equals(element)) {
                    xmlEvent = xmlEventReader.nextEvent();
                    if(xmlEvent.isEndElement()){
                        value = "0";
                    }else{
                        value = xmlEvent.toString();
                    }
                    break;
                }
            }
        }
        if (value != ""){
            return value;
        }else{
            ByteArrayInputStream einputStream = new ByteArrayInputStream(byteArray);
            XMLInputFactory exmlInputFactory = XMLInputFactory.newInstance();
            XMLEventReader exmlEventReader = exmlInputFactory.createXMLEventReader(einputStream);
            while (exmlEventReader.hasNext()) {
                XMLEvent exmlEvent = exmlEventReader.nextEvent();
                if (exmlEvent.isStartElement()) {
                    StartElement estartElement = exmlEvent.asStartElement();
                    if (element == "token1"){
                        if (estartElement.getName().getLocalPart().equals("code")) {
                            exmlEvent = exmlEventReader.nextEvent();
                            if(exmlEvent.isEndElement()){
                                value = "0";
                            }else{
                                value = exmlEvent.toString();
                            }
                            break;
                        }
                    }else if (element == "token2"){
                        if (estartElement.getName().getLocalPart().equals("error")) {
                            exmlEvent = exmlEventReader.nextEvent();
                            if(exmlEvent.isEndElement()){
                                value = "0";
                            }else{
                                value = exmlEvent.toString();
                            }
                            break;
                        }
                    }
                }
            }return value;
        }
    }

//Experian =========================================================================================

    private static String getValueByQName(String xmlString, String element, String qname) throws UnsupportedEncodingException, XMLStreamException {
        String value = "";
        byte[] byteArray = xmlString.getBytes("UTF-8");
        ByteArrayInputStream inputStream = new ByteArrayInputStream(byteArray);
        XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
        XMLEventReader xmlEventReader = xmlInputFactory.createXMLEventReader(inputStream);

        while (xmlEventReader.hasNext()) {
            XMLEvent xmlEvent = xmlEventReader.nextEvent();
            if (xmlEvent.isStartElement()) {
                StartElement startElement = xmlEvent.asStartElement();
                if (startElement.getName().getLocalPart().equals(element)) {
                    Attribute scoreAttr = startElement.getAttributeByName(new QName(qname));
                    if (scoreAttr != null) {
                        if (CommonUtils.isNotEmpty(scoreAttr.getValue())) {
                            value = scoreAttr.getValue();
                        }
                        break;
                    }
                }
            }
        }
        return value;
    }

    private static String getValueByAttribute(String xmlString, String element, String qname) throws UnsupportedEncodingException, XMLStreamException {
        String value = "";
        byte[] byteArray = xmlString.getBytes("UTF-8");
        ByteArrayInputStream inputStream = new ByteArrayInputStream(byteArray);
        XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
        XMLEventReader xmlEventReader = xmlInputFactory.createXMLEventReader(inputStream);

        while (xmlEventReader.hasNext()) {
            XMLEvent xmlEvent = xmlEventReader.nextEvent();
            if (xmlEvent.isStartElement()) {
                StartElement startElement = xmlEvent.asStartElement();
                if (startElement.getName().getLocalPart().equals(element)) {
                  xmlEvent = xmlEventReader.nextEvent();
                    if(xmlEvent.isEndElement()){
                      value = "0";
                    }else{
                      value = xmlEvent.toString();
                    }
                  break;
                }
            }
        }
        return value;
    }

}