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

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

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
	
	@Autowired
	private SessionHandler sessionHandler;
	

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

		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); // 수정 리스트 얻기
		
		Map hm = null;
		int up_sync= 0;
		int up_mobile= 0;
		Boolean loc_sync = false;
		Boolean loc_mobile = false;
	
		if(loc_sync == true){
			up_sync =1;
		}
		
		if(loc_mobile == true){
			up_mobile =1;
		}
		
		Map<String, Object> updateMap = (Map<String, Object>) updateList.get(0);
		
		updateMap.put("up_sync", up_sync);
		updateMap.put("up_mobile", up_mobile);
		
		loc.updateLocationInfo(updateMap);
		

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	
	@SuppressWarnings("static-access")
	@RequestMapping(value = "/insLocation.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> insLocation(@RequestParam Map<String, Object> params, Model model) {
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = 0;
		int inis_sync= 0;
		int inmobile= 0;
		Boolean loc_Sync = false;
		Boolean loc_Mobile = false;
				
		if(sessionVO==null){
			loginId=99999999;			
		}else{
			loginId=sessionVO.getUserId();
		}
		if(loc_Sync == true){
			inis_sync =1;
		}
		
		if(loc_Mobile == true){
			inmobile =1;
		}
		
		String inwarecd     = (String) params.get("inwarecd");
		String inwarenm     = (String) params.get("inwarenm");
		String inaddr1     = (String) params.get("inaddr1");
		String inaddr2     = (String) params.get("inaddr2");
		String inaddr3     = (String) params.get("inaddr3");
		String incontact1     = (String) params.get("incontact1");
		String incontact2     = (String) params.get("incontact2");
		String instockgrade     = (String) params.get("instockgrade");
		String inwarebranch     = (String) params.get("inwarebranch");
		int incnty     = CommonUtils.intNvl((String) params.get("incountry"));
		int instat     = CommonUtils.intNvl((String) params.get("instate"));
		int inarea     = CommonUtils.intNvl((String) params.get("inarea"));
		int inpost     = CommonUtils.intNvl((String) params.get("inpostcd"));		
		
		Map<String, Object> insmap = new HashMap();				
		
		insmap.put("inwarecd", inwarecd);
		insmap.put("inwarenm" , inwarenm);
		insmap.put("inaddr1"  ,inaddr1 );
		insmap.put("inaddr2"  ,inaddr2);
		insmap.put("inaddr3", inaddr3);
		insmap.put("incontact1" , incontact1 );
		insmap.put("incontact2"  ,incontact2);
		insmap.put("inarea"  , inarea);
		insmap.put("inpost"  , inpost );
		insmap.put("incnty"  , incnty);
		insmap.put("instat"  ,instat );
		insmap.put("intype_id"  ,277);
		insmap.put("incode2"  ,inwarecd);
		insmap.put("instus_id"  ,1);
		insmap.put("ingrad"  , instockgrade );
		insmap.put("indesc2",inwarenm);
		insmap.put("inup_user_id"  ,loginId);
		insmap.put("inbranch"  ,inwarebranch);
		insmap.put("inis_sync" ,inis_sync);
		insmap.put("inmobile"  ,inmobile);		
		
		loc.insertLocationInfo(insmap);
		

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/locationDelete.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteLocation(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String locid        = request.getParameter("locid");
		
		Map<String, Object> smap = new HashMap();
		smap.put("locid"  , locid);
		
		loc.deleteLocationInfo(smap);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	
	
	
	
	

}
