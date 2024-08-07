/**
 *
 */
package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.bs.HsMaintenanceService;

import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @author HQIT-HUIDING
 * @date Jul 21, 2020
 *
 */
@Service("hsMaintenanceService")
public class HsMaintenanceServiceImpl implements HsMaintenanceService{

	private static final Logger logger = LoggerFactory.getLogger(HsMaintenanceServiceImpl.class);

	@Resource(name="hsMaintenanceMapper")
	private HsMaintenanceMapper hsMaintenanceMapper;

	@Resource(name = "hsAccConfigMapper")
	private HsAccConfigMapper hsAccConfigMapper;

	public List<EgovMap> selectCurrMonthHsList(Map<String, Object> params){
		return hsMaintenanceMapper.selectCurrMonthHsList(params);
	}

	@Override
	public String updateAssignCodyBulk(Map<String, Object> params){
		logger.info("###params: " + params.toString());

		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
	    String rtnValue = "";
	    String line = System.getProperty("line.separator");

	    if (updateItemList.size() > 0) {

	      for (int i = 0; i < updateItemList.size(); i++) {
	        Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
	        logger.debug("updateMap : {}" + updateMap);
	        hsAccConfigMapper.updateAssignCody(updateMap);
//	        hsAccConfigMapper.updateAssignCody90D(updateMap);

	        if (i != 0) {
	          rtnValue += "<br>";
	        }

	        rtnValue += "* Cody Transfer for HS Order ‘" + updateMap.get("no") + "'" + "<br>from " + "'"
	            + updateMap.get("oldCodyCd") + "'" + " to " + "'" + updateMap.get("codyCd") + "'" + "\r\n";
	        rtnValue = rtnValue.replace("\n", line);
	      }
	    }
	    return rtnValue;
	}
}
