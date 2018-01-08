package com.coway.trust.biz.sales.ccp.impl;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import javax.xml.transform.stream.StreamResult;
import com.coway.trust.biz.sales.ccp.CcpCTOSB2BService;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpCTOSB2BService")
public class CcpCTOSB2BServiceImpl extends EgovAbstractServiceImpl implements CcpCTOSB2BService{

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCTOSB2BServiceImpl.class);
	
	@Resource(name = "ccpCTOSB2BMapper")
	private CcpCTOSB2BMapper ccpCTOSB2BMapper;
	
	@Value("${web.resource.upload.file}")
	private String webPath;
	
	@Autowired
	private org.springframework.core.io.ResourceLoader resourceLoader;
	
	@Override
	public List<EgovMap> selectCTOSB2BList(Map<String, Object> params) throws Exception {
		
		return ccpCTOSB2BMapper.selectCTOSB2BList(params);
	}


	@Override
	public List<EgovMap> getCTOSDetailList(Map<String, Object> params) throws Exception {
		
		return ccpCTOSB2BMapper.getCTOSDetailList(params);
	}


	@Override
	public Map<String, Object> getResultRowForCTOSDisplay(Map<String, Object> params) throws Exception {
		
		EgovMap rtnMap = ccpCTOSB2BMapper.getResultRowForCTOSDisplay(params);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(rtnMap != null){
			if(rtnMap.get("resultRaw") != null){
				/*___Return Path___*/
				String subPath = SalesConstants.FICO_CTOS_REPORT_SUBPATH;
				String fileName = SalesConstants.FICO_CTOS_REPORT_FILENAME;
				
				/*___Result Raw___*/
				String resultRaw = String.valueOf(rtnMap.get("resultRaw"));
				InputStream is = new ByteArrayInputStream(resultRaw.getBytes());
				StreamSource source = new StreamSource(is);  // raw_data xml data
				
				/*___Style Sheet___*/
				String rePaht = "";
				
				LOGGER.info("________________________________params : " + params.toString());
				if(SalesConstants.FICO_VIEW_TYPE.equals(params.get("viewType"))){
					rePaht = resourceLoader.getResource("classpath:template/stylesheet/fico_report.xsl").getURI().getPath();
					LOGGER.info("_______________________________ FICO VIEW " + params.get("viewType"));
				}else{
					rePaht = resourceLoader.getResource("classpath:template/stylesheet/ctos_report.xsl").getURI().getPath();
					LOGGER.info("_______________________________ CTOS_VIEW " + params.get("viewType"));
				}
				LOGGER.info("###################### Style Sheet Path :   " + rePaht);
				
				//trim
				rePaht.trim();
				
				if(rePaht.startsWith("/")){
					rePaht = rePaht.substring(1);
				}
				
				//StreamSource stylesource = new StreamSource("C:/works/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp3/wtpwebapps/etrust/WEB-INF/classes/template/stylesheet/ctos_report.xsl"); // xsl file...
				StreamSource stylesource = new StreamSource(rePaht); // xsl file...
				TransformerFactory factory = TransformerFactory.newInstance();
				Transformer transformer = factory.newTransformer(stylesource);
				
				//String htPath = resourceLoader.getResource("resources/WebShare/"+subPath+"/"+fileName).getURI().getPath();
				String htPath = webPath+"/"+subPath+"/"+fileName;

				LOGGER.info("########################### HTML PATH : " + htPath);
				
				File file = new File(htPath);
				if(!file.getParentFile().exists()){
					LOGGER.info("######## Not Found File!!!!");
					//make dir
					file.getParentFile().mkdirs();
					// make file
					FileWriter fileWriter = new FileWriter(file);
					BufferedWriter out = new BufferedWriter(fileWriter);
					out.flush();
					out.close();
				}
				
				StreamResult result = new StreamResult(new File(htPath)); //result html
				transformer.transform(source, result);
				
				resultMap.put("webPath", webPath);
				resultMap.put("subPath", subPath);
				resultMap.put("fileName", fileName);
			}
		}
		return resultMap;
	}
	
}
