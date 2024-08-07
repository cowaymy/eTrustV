package com.coway.trust.biz.sales.ccp.impl;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import javax.xml.transform.stream.StreamResult;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.CcpExpB2BService;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpExpB2BService")
public class CcpExpB2BServiceImpl extends EgovAbstractServiceImpl implements CcpExpB2BService{

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpExpB2BServiceImpl.class);

	@javax.annotation.Resource(name = "ccpExpB2BMapper")
	private CcpExpB2BMapper ccpExpB2BMapper;

	@Value("${web.resource.upload.file}")
	private String webPath;

	/*@Autowired
	private org.springframework.core.io.ResourceLoader resourceLoader;*/

	@Override
	public List<EgovMap> selectEXPERIANB2BList(Map<String, Object> params) throws Exception {

		return ccpExpB2BMapper.selectEXPERIANB2BList(params);
	}


	@Override
	public List<EgovMap> getExpDetailList(Map<String, Object> params) throws Exception {

		return ccpExpB2BMapper.getExpDetailList(params);
	}


	@Override
	public Map<String, Object> getResultRowForExpDisplay(Map<String, Object> params) throws Exception {

		EgovMap rtnExpMap = ccpExpB2BMapper.getResultRowForExpDisplay(params);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(rtnExpMap != null){
			if(rtnExpMap.get("resultRaw") != null){
				/*___Return Path___*/
				String subPath = SalesConstants.EXPERIAN_REPORT_SUBPATH;
				String fileName = SalesConstants.EXPERIAN_REPORT_FILENAME;

				/*___Result Raw___*/
				String expresultRaw = String.valueOf(rtnExpMap.get("resultRaw"));
				InputStream expis = new ByteArrayInputStream(expresultRaw.getBytes());
				StreamSource expsource = new StreamSource(expis);  // raw_data xml data

				/*___Style Sheet___*/
				String reExpPaht = "";

				String ExpLayout = String.valueOf(rtnExpMap.get("rptType"));
				LOGGER.info("________________________________ExpLayout : " + ExpLayout);
				LOGGER.info("________________________________params : " + params.toString());
				if(ExpLayout.equals("IRISS")){
				    reExpPaht = "template/stylesheet/iriss.xsl";
					LOGGER.info("_______________________________ IRISS VIEW " + params.get("viewType"));
				}else{
				    reExpPaht = "template/stylesheet/iris.xsl";
					LOGGER.info("_______________________________ IRIS VIEW " + params.get("viewType"));
				}
				LOGGER.info("###################### Style Sheet Path :   " + reExpPaht);

				Resource resourceExp = new ClassPathResource(reExpPaht);
				//trim
				reExpPaht.trim();

				if(reExpPaht.startsWith("/")){
				    reExpPaht = reExpPaht.substring(1);
				}

				//StreamSource stylesource = new StreamSource("C:/works/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp3/wtpwebapps/etrust/WEB-INF/classes/template/stylesheet/ctos_report.xsl"); // xsl file...
				StreamSource expstylesource = new StreamSource(resourceExp.getFile()); // xsl file...
				TransformerFactory expfactory = TransformerFactory.newInstance();
				Transformer exptransformer = expfactory.newTransformer(expstylesource);

				//String htPath = resourceLoader.getResource("resources/WebShare/"+subPath+"/"+fileName).getURI().getPath();
				String exphtPath = webPath+"/"+subPath+"/"+fileName;

				LOGGER.info("########################### HTML PATH : " + exphtPath);

				File expfile = new File(exphtPath);
				if(!expfile.getParentFile().exists()){
					LOGGER.info("######## Not Found File!!!!");
					//make dir
					expfile.getParentFile().mkdirs();
					// make file
					FileWriter expfileWriter = new FileWriter(expfile);
					BufferedWriter expout = new BufferedWriter(expfileWriter);
					expout.flush();
					expout.close();
				}

				StreamResult expresult = new StreamResult(new File(exphtPath)); //result html
				exptransformer.transform(expsource, expresult);

				resultMap.put("webPath", webPath);
				resultMap.put("subPath", subPath);
				resultMap.put("fileName", fileName);
			}
		}
		return resultMap;
	}


	  @Override
		public int  saveExpPromoB2BUpdate(Map<String, Object> params) {

			List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);


			int o=0;
	  	if (updateItemList.size() > 0) {
				for (int i = 0; i < updateItemList.size(); i++) {
					Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);

					int check = Integer.parseInt(String.valueOf(updateMap.get("b2b")));
					updateMap.put("userId", params.get("userId"));

				if(check == 0){
				    ccpExpB2BMapper.savePromoB2BUpdate(updateMap) ;
				}
				else
				{
				    ccpExpB2BMapper.savePromoB2BUpdate2(updateMap) ;
				}
				}
			}

	  	if (updateItemList.size() > 0) {
	  		for (int j = 0; j < updateItemList.size(); j++) {
	  			Map<String, Object> updateMapCHS = (Map<String, Object>) updateItemList.get(j);

	  			int checkCHS = Integer.parseInt(String.valueOf(updateMapCHS.get("chs")));
	  			updateMapCHS.put("userId", params.get("userId"));

	  			if(checkCHS == 0){
	  			    ccpExpB2BMapper.savePromoCHSUpdate(updateMapCHS) ;
	  			}else{
	  			    ccpExpB2BMapper.savePromoCHSUpdate2(updateMapCHS) ;
	  			}
	  		}
	  	}


			return o ;
		}

}
