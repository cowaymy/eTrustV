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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
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
@RequestMapping(value = "/organization")
public class LocationController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "locationService")
	private LocationService loc;

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

}
