package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.web.organization.organization.MemberEventListController;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hsManualService")
public class HsManualServiceImpl extends EgovAbstractServiceImpl implements HsManualService {

	private static final Logger logger = LoggerFactory.getLogger(MemberEventListController.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Resource(name = "hsManualMapper")
	private HsManualMapper hsManualMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	
	@Override
	public List<EgovMap> selectHsManualList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		StringTokenizer str1 = new StringTokenizer(params.get("myBSMonth").toString());
		
//		while (str1.hasMoreElements()) { 
////	         String result = str1.nextElement().toString();  //공백으로 자를시 사용
//	         String result = str1.nextToken("/");            //특정문자로 자를시 사용
//	         System.out.println("결과 : " + result +", 사이즈 :"+result.length()); 
//		}

		
		
		for(int i =0; i <= 1 ; i++) {
			str1.hasMoreElements();
			String result = str1.nextToken("/");            //특정문자로 자를시 사용
			
			logger.debug("iiiii: {}", i);
			
			if(i==0){
				params.put("myBSMonth", result);
				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
			}else{
				params.put("myBSYear", result);
				logger.debug("myBSYear : {}", params.get("myBSYear"));
			}
			
			
		}
		
		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		
		return hsManualMapper.selectHsManualList(params);
	}

	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectBranchList(params);
	}

	@Override
	public List<EgovMap> selectCtList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectCtList(params);
	}


	@Override
	public List<EgovMap> getCdUpMemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 3);
		return hsManualMapper.getCdUpMemList(params);
	}

	
	@Override
	public List<EgovMap> getCdList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 4);
		return hsManualMapper.getCdUpMemList(params);
	}

	
	
}
