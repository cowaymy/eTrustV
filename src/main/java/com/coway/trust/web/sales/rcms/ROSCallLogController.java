package com.coway.trust.web.sales.rcms;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.rcms.ROSCallLogService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/rcms")
public class ROSCallLogController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ROSCallLogController.class);
	
	@Resource(name = "rosCallLogService")
	private ROSCallLogService rosCallLogService;
	
	@RequestMapping(value = "/rosCallLogList.do")
	public String rosCallLogList (@RequestParam Map<String, Object> params) throws Exception{
		
		return "sales/rcms/rosCallLogList";
	}
	
	
	@RequestMapping(value = "/getAppTypeList")
	public ResponseEntity<List<EgovMap>> getAppTypeList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> appTypeList = null;
		
		appTypeList = rosCallLogService.getAppTypeList(params);
		
		return ResponseEntity.ok(appTypeList);
		
	}
	
	
	@RequestMapping(value = "/selectRosCallLogList")
	public ResponseEntity<List<EgovMap>> selectRosCallLogList(@RequestParam Map<String, Object> params, HttpServletRequest request )throws Exception{
		
		String appTypeArr[] = request.getParameterValues("appType");
		String rentalArr[] = request.getParameterValues("rentalStatus"); 
		
		params.put("appTypeArr", appTypeArr);
		params.put("rentalArr", rentalArr);
		
		List<EgovMap> rosCallList = null;
		
		LOGGER.info("############## selectRosCallLogList Params : " + params.toString());
		
		rosCallList = rosCallLogService.selectRosCallLogList(params);
		
		return ResponseEntity.ok(rosCallList);
		
	}
}
