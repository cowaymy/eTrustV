/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.masterdata;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.coway.trust.util.CommonUtils;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.coway.trust.AppConstants;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.materialdata.MaterialService;
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/logistics/material")
public class MstDataController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "mstdataservice")
	private MaterialService mst;
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/mylog007.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/MaterialData/MY_LOG_E007";
	}
	
	@RequestMapping(value = "/materialcdsearch.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectMaterialCodeList(@RequestBody Map<String, Object> params, Model model) throws Exception {
		
		
		List<EgovMap> codeList = mst.selectStockMstList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", codeList);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/materialitemList.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectMaterialItemList(@RequestBody Map<String, Object> params, Model model) throws Exception {
		List<EgovMap> codeList = mst.selectMaterialMstItemList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", codeList);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/materialitemTypeList.do" , method = RequestMethod.GET)
	public ResponseEntity<Map> selectMaterialItemTypeList(@RequestParam Map<String, Object> params, Model model) throws Exception {
		
		EgovMap codeList = mst.selectMaterialMstItemTypeList();
		return ResponseEntity.ok(codeList);
	}
	
	@RequestMapping(value = "/materialUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSampleGrid(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) {

		List<Object> updateList = params.get(AppConstants.AUIGrid_UPDATE); // 수정 리스트 얻기
		
		List<Object> removeList = params.get(AppConstants.AUIGRID_REMOVE); // 수정 리스트 얻기
		
		logger.debug("101Line :::: " + removeList.size());
		
		Map<String, Object> removeMap = (Map<String, Object>) removeList.get(0);
		
		logger.debug(" itmId ::: " + removeMap.get("itmId"));
		//Map hm = null;
		//Map<String, Object> updateMap = (Map<String, Object>) updateList.get(0);
		
		//loc.updateLocationInfo(updateMap);
		

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}