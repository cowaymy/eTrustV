
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.hsfilter.HsFilterLooseService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HsFilterLooseService")
public class HsFilterLooseServiceImpl extends EgovAbstractServiceImpl implements HsFilterLooseService
{
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "HsFilterLooseMapper")
	private HsFilterLooseMapper hsFilterLooseMapper;

	@Override
	public List<EgovMap> selectHSFilterLooseList(Map<String, Object> params) {

		logger.debug(params.toString());
		return hsFilterLooseMapper.selectHSFilterLooseList(params);
	}

	@Override
	public void updateMergeLOG0107M(Map<String, Object> params) {

		// TODO Auto-generated method stub
		List<Map<String, Object>> udtList = (List<Map<String, Object>>) params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Map<String, Object>> addList = (List<Map<String, Object>>) params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList


	logger.debug(params.toString());

        if (addList !=null ){
    		if (addList.size() > 0) {
    			for (Object obj : addList) {
    				((Map<String, Object>) obj).put("crtUserId", params.get("userId"));
    				((Map<String, Object>) obj).put("updUserId", params.get("userId"));

    				hsFilterLooseMapper.updateMergeLOG0107M((Map<String, Object>) obj);
    			}
    		}
        }

        if (udtList !=null ){
    		if (udtList.size() > 0) {
    			for (Object obj : udtList) {
    				((Map<String, Object>) obj).put("crtUserId", params.get("userId"));
    				((Map<String, Object>) obj).put("updUserId", params.get("userId"));

    				hsFilterLooseMapper.updateMergeLOG0107M((Map<String, Object>) obj);
    			}
    		}
        }
	}



	@Override
	public void updateMergeLOG0109M(Map<String, Object> params) {

		// TODO Auto-generated method stub
		List<Map<String, Object>> udtList = (List<Map<String, Object>>) params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Map<String, Object>> addList = (List<Map<String, Object>>) params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList


	logger.debug(params.toString());

        if (addList !=null ){
    		if (addList.size() > 0) {
    			for (Object obj : addList) {
    				((Map<String, Object>) obj).put("crtUserId", params.get("userId"));
    				((Map<String, Object>) obj).put("updUserId", params.get("userId"));

    				hsFilterLooseMapper.updateMergeLOG0109M((Map<String, Object>) obj);
    			}
    		}
        }

        if (udtList !=null ){
    		if (udtList.size() > 0) {
    			for (Object obj : udtList) {
    				((Map<String, Object>) obj).put("crtUserId", params.get("userId"));
    				((Map<String, Object>) obj).put("updUserId", params.get("userId"));

    				hsFilterLooseMapper.updateMergeLOG0109M((Map<String, Object>) obj);
    			}
    		}
        }
	}



	@Override
	public List<EgovMap> selectHSFilterLooseMiscList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsFilterLooseMapper.selectHSFilterLooseMiscList(params);
	}



	@Override
	public List<EgovMap> selectMappingLocationType(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsFilterLooseMapper.selectMappingLocationType(params);
	}


	@Override
	public List<EgovMap> selectMappingCdbLocationList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsFilterLooseMapper.selectMappingCdbLocationList(params);
	}



	@Override
	public List<EgovMap> selectMiscBranchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsFilterLooseMapper.selectMiscBranchList(params);
	}

	@Override
	public List<EgovMap> selectHSFilterMappingList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsFilterLooseMapper.selectHSFilterMappingList(params);
	}








}
