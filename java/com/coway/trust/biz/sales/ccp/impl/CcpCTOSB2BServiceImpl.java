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
import com.coway.trust.biz.sales.ccp.CcpCTOSB2BService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpCTOSB2BService")
public class CcpCTOSB2BServiceImpl extends EgovAbstractServiceImpl implements CcpCTOSB2BService{

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCTOSB2BServiceImpl.class);

	@javax.annotation.Resource(name = "ccpCTOSB2BMapper")
	private CcpCTOSB2BMapper ccpCTOSB2BMapper;

	@Value("${web.resource.upload.file}")
	private String webPath;

	/*@Autowired
	private org.springframework.core.io.ResourceLoader resourceLoader;*/

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
					rePaht = "template/stylesheet/fico_report.xsl";
					LOGGER.info("_______________________________ FICO VIEW " + params.get("viewType"));
				}else{
					rePaht = "template/stylesheet/ctos_report.xsl";
					LOGGER.info("_______________________________ CTOS_VIEW " + params.get("viewType"));
				}
				LOGGER.info("###################### Style Sheet Path :   " + rePaht);

				Resource resource = new ClassPathResource(rePaht);
				//trim
				rePaht.trim();

				if(rePaht.startsWith("/")){
					rePaht = rePaht.substring(1);
				}

				//StreamSource stylesource = new StreamSource("C:/works/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp3/wtpwebapps/etrust/WEB-INF/classes/template/stylesheet/ctos_report.xsl"); // xsl file...
				StreamSource stylesource = new StreamSource(resource.getFile()); // xsl file...
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


	  @Override
		public int  savePromoB2BUpdate(Map<String, Object> params) {

			List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);


			int o=0;
	  	if (updateItemList.size() > 0) {
				for (int i = 0; i < updateItemList.size(); i++) {
					Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);

					int check = Integer.parseInt(String.valueOf(updateMap.get("b2b")));
					updateMap.put("userId", params.get("userId"));

				if(check == 0){
					ccpCTOSB2BMapper.savePromoB2BUpdate(updateMap) ;
				}
				else
				{
					ccpCTOSB2BMapper.savePromoB2BUpdate2(updateMap) ;
				}
				}
			}

	  	if (updateItemList.size() > 0) {
	  		for (int j = 0; j < updateItemList.size(); j++) {
	  			Map<String, Object> updateMapCHS = (Map<String, Object>) updateItemList.get(j);

	  			int checkCHS = Integer.parseInt(String.valueOf(updateMapCHS.get("chs")));
	  			updateMapCHS.put("userId", params.get("userId"));

	  			if(checkCHS == 0){
	  				ccpCTOSB2BMapper.savePromoCHSUpdate(updateMapCHS) ;
	  			}
	  			else
	  			{
	  				ccpCTOSB2BMapper.savePromoCHSUpdate2(updateMapCHS) ;
	  			}
	  		}
	  	}


			return o ;
		}

	  @Override
		public Map<String, Object>  reuploadCTOSB2BList(Map<String, Object> params, SessionVO sessionVO) {

		  int userId = sessionVO.getUserId();
		  LOGGER.info("########################### UPDATE USER ID : " + userId);

		  params.put("userId",userId);

		  return ccpCTOSB2BMapper.getReuploadB2B(params);
		}

	  @Override
	  public EgovMap getCurrentTower(Map<String, Object> params) throws Exception {

	    return ccpCTOSB2BMapper.getCurrentTower(params);
	  }

	  public int  updateCurrentTower(Map<String, Object> params) {
	    return ccpCTOSB2BMapper.updateCurrentTower(params);
	  }

	  @Override
	  public List<EgovMap> selectAgeGroupList(Map<String, Object> params) {
	    return ccpCTOSB2BMapper.selectAgeGroupList(params);
	 }

	  @Override
	  public int  updateAgeGroup(Map<String, Object> params) {
		    return ccpCTOSB2BMapper.updateAgeGroup(params);
	  }

	  @Override
	  public EgovMap getCurrentAgeGroup(Map<String, Object> params) throws Exception {
	    return ccpCTOSB2BMapper.getCurrentAgeGroup(params);
	  }


}
