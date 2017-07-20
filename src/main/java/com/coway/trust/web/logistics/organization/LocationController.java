/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.organization;

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

import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/logistics/organization")
public class LocationController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "locationService")
	private LocationService loc;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/Location.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/Organization/locationList";
	}

	@RequestMapping(value = "/LocationList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectLocationList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String statusCd     = request.getParameter("status");
		String branchId     = request.getParameter("branchid");
		String locdesc      = request.getParameter("locdesc");
		String loccd        = request.getParameter("loccd");
		
		Map<String, Object> smap = new HashMap();
		smap.put("branch", branchId);
		smap.put("status" , statusCd);
		smap.put("locdesc"  , locdesc);
		smap.put("loccd"  , loccd);

		List<EgovMap> list = loc.selectLocationList(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/locationDetail.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectLocationDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String locid        = request.getParameter("locid");
		
		Map<String, Object> smap = new HashMap();
		smap.put("warelocid"  , locid);

		List<EgovMap> list = loc.selectLocationList(smap);
		
		List<EgovMap> stock = loc.selectLocationStockList(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);
		map.put("stock", stock);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/locationUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSampleGrid(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) {

		List<Object> updateList = params.get(AppConstants.AUIGrid_UPDATE); // 수정 리스트 얻기
		
		Map hm = null;
		Map<String, Object> updateMap = (Map<String, Object>) updateList.get(0);
		
		loc.updateLocationInfo(updateMap);
		

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/insLocation.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> insLocation(@RequestParam Map<String, Object> params, Model model) {

		String inwarecd     = (String) params.get("inwarecd");
		String inwarenm     = (String) params.get("inwarenm");
		String inaddr1     = (String) params.get("inaddr1");
		String inaddr2     = (String) params.get("inaddr2");
		String inaddr3     = (String) params.get("inaddr3");
		String incontact1     = (String) params.get("incontact1");
		String incontact2     = (String) params.get("incontact2");
		
		Map<String, Object> insmap = new HashMap();				
		
		insmap.put("inwarecd", inwarecd);
		insmap.put("inwarenm" , inwarenm);
		insmap.put("inaddr1"  ,inaddr1 );
		insmap.put("inaddr2"  ,inaddr2);
		insmap.put("inaddr3", inaddr3);
		insmap.put("incontact1" , incontact1 );
		insmap.put("incontact2"  ,incontact2);
		insmap.put("inarea"  ,1);
		insmap.put("inpost"  ,2 );
		insmap.put("instat"  ,3 );
		insmap.put("incnty"  ,4);
		insmap.put("inbranch"  ,5);
		insmap.put("intype_id"  ,6);
		insmap.put("ingrad"  , 'A' );
		insmap.put("instus_id"  ,7);
		insmap.put("inup_user_id"  ,8 );
		insmap.put("incode2"  ,"");
		insmap.put("indesc2","" );
		insmap.put("inis_sync" ,9);
		insmap.put("inmobile"  ,1234 );		
		
		loc.insertLocationInfo(insmap);
		

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	
	
	
	
	
	
	

}
