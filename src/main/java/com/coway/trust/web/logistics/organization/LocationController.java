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
	public ResponseEntity<Map> selectLocationList(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String statusCd = request.getParameter("status");
		String branchId = request.getParameter("branchid");
		String locdesc  = request.getParameter("locdesc");
		String loccd    = request.getParameter("loccd");

		String[] loctype    = request.getParameterValues("loctype");
		String locgrad    = request.getParameter("locgrad");

		Map<String, Object> smap = new HashMap();
		smap.put("branch"  , branchId);
		smap.put("status"  , statusCd);
		smap.put("locdesc" , locdesc);
		smap.put("loccd"   , loccd);

		smap.put("loctype" , loctype);
		smap.put("locgrad" , locgrad);

		List<EgovMap> list = loc.selectLocationList(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/locationDetail.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectLocationDetail(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String locid = request.getParameter("locid");

		Map<String, Object> smap = new HashMap();
		smap.put("warelocid", locid);

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

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = 0;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		Map hm = null;
		int up_sync = 0;
		int up_mobile = 0;
		Boolean loc_sync = false;
		Boolean loc_mobile = false;

		if (loc_sync == true) {
			up_sync = 1;
		}

		if (loc_mobile == true) {
			up_mobile = 1;
		}

		Map<String, Object> updateMap = (Map<String, Object>) updateList.get(0);

		updateMap.put("up_sync", up_sync);
		updateMap.put("up_mobile", up_mobile);
		updateMap.put("up_user_id", loginId);

		logger.debug("locstus    값 : {}", params.get("locstus"));


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
		int inis_sync = 0;
		int inmobile = 0;
		Boolean loc_Sync = false;
		Boolean loc_Mobile = false;

		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String inwarecd      = (String) params.get("inwarecd");
		String inwarenm      = (String) params.get("inwarenm");

		String incontact1    = (String) params.get("incontact1");
		String incontact2    = (String) params.get("incontact2");
		String instockgrade  = (String) params.get("instockgrade");
		String ilocationtype = (String) params.get("ilocationtype");
		String inwarebranch1 = (String) params.get("inwarebranch1");
		String inwarebranch2 = (String) params.get("inwarebranch2");
		String inwarebranch3 = (String) params.get("inwarebranch3");
		String inwarebranch4 = (String) params.get("inwarebranch4");
		String inwarebranch5 = (String) params.get("inwarebranch5");

		String iareaId       = (String) params.get("iareaId");
		String iaddrdtl      = (String) params.get("iaddrdtl");
		String istreet       = (String) params.get("istreet");

		String ipdchk        = (String) params.get("ipdchk");
		String iftchk        = (String) params.get("iftchk");
		String iptchk        = (String) params.get("iptchk");

		String cdccode       = (String) params.get("icdccode");
		if (ilocationtype.equalsIgnoreCase("01")) { // CDC type, auto assign CDC code = location code
			cdccode = 	inwarecd;
		}

		String rdccode       = (String) params.get("irdccode");

		String plant         = (String) params.get("iplant");
		String slplant         = (String) params.get("islplant");
		String irem          = (String) params.get("irem");

		// Added for Flagging CDC to be used in Homecare or Home Appliance platform. By Hui Ding, 2020-08-07
		String haChk		= (String) params.get("ihaChk");
		String hcChk		= (String) params.get("ihcChk");


		if (haChk != null && "on".equals(haChk)){
			haChk = "Y";
    	}
    	if (hcChk != null  && "on".equals(hcChk)){
    		hcChk = "Y";
    	}

    	logger.info("###haChk: " + haChk);
		logger.info("###hcChk: " + hcChk);

		String iserialRequireChkYn  = (String) params.get("iserialRequireChkYn"); // 20191122 KR-OHK Serial Required Check Y/N Add

		if (ipdchk != null && "on".equals(ipdchk)){
				ipdchk = "Y";
		}
		if (iftchk != null  && "on".equals(iftchk)){
				iftchk = "Y";
		}
		if (iptchk != null && "on".equals(iptchk)){
				iptchk = "Y";
		}

		// Added to insert RFD doc no when creating CDC, RDC, CDC&RDC location
		String docNo = params.get("inDocNo") != null ? params.get("inDocNo").toString().trim() : null;


		Map<String, Object> insmap = new HashMap();

		insmap.put("inwarecd"    , inwarecd);
		insmap.put("inwarenm"    , inwarenm);
		insmap.put("incontact1"  , incontact1);
		insmap.put("incontact2"  , incontact2);
		insmap.put("intype_id"   , 277);
		insmap.put("incode2"     , inwarecd);
		insmap.put("instus_id"   , 1);
		insmap.put("ingrad"      , instockgrade);
		insmap.put("indesc2"     , inwarenm);
		insmap.put("inup_user_id", loginId);

		insmap.put("branch1"     , inwarebranch1);
		insmap.put("branch2"     , inwarebranch2);
		insmap.put("branch3"     , inwarebranch3);
		insmap.put("branch4"     , inwarebranch4);
		insmap.put("branch5"     , inwarebranch5);


		insmap.put("pdchk"       , ipdchk);
		insmap.put("ftchk"       , iftchk);
		insmap.put("ptchk"       , iptchk);

		insmap.put("areaid"     , iareaId );
		insmap.put("addrdtl"     , iaddrdtl);
		insmap.put("street"     , istreet );

		insmap.put("locationtype", ilocationtype);

		insmap.put("cdccode"     , cdccode);
		insmap.put("rdccode"     , rdccode);

		insmap.put("inis_sync"   , inis_sync);
		insmap.put("inmobile"    , inmobile);

		insmap.put("plant"       , plant);
		insmap.put("slplant"     , slplant);
		insmap.put("rem"         , irem);

		insmap.put("serialRequireChkYn"         , iserialRequireChkYn);

		// Added for Flagging CDC to be used in Homecare or Home Appliance platform. By Hui Ding, 2020-08-07
		insmap.put("haChk"       , haChk);
		insmap.put("hcChk"       , hcChk);

		// Added RFD doc no when creating CDC, RDC, CDC&RDC new location. Hui Ding, 24/02/2022
		insmap.put("docNo", 	docNo);

		int inlocid =loc.insertLocationInfo(insmap);
		//System.out.println("inlocid 값!!!  : " + inlocid);
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(inlocid);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/locationDelete.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> deleteLocation(@RequestParam Map<String, Object> params,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//String locid = request.getParameter("locid");
		logger.debug("locid    값 : {}", params.get("locid"));
		Map<String, Object> smap = new HashMap();
		smap.put("locid", params.get("locid"));
		logger.debug("smap.locid    값 : {}", smap.get("locid"));
		loc.deleteLocationInfo(smap);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/locationCdSearch.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectLocationCodeList(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		if (params.get("locgb") != null ){
    		List<String> list = (List)params.get("locgb");
    		if (!list.isEmpty()){
    			String[] locgb = new String[list.size()];
    			for (int i = 0 ; i < list.size(); i++){
    				locgb[i] = list.get(i);
        		}
        		params.put("locgb" , locgb);
    		}
		}

		List<EgovMap> codeList = loc.selectLocationCodeList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", codeList);

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/locationchk.do", method = RequestMethod.POST)
	public ResponseEntity<Map> locationchk(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		//String loccode = request.getParameter("loccode");

		String loccode = (String) params.get("loccode");

		logger.debug("loccode    값 : {}", loccode);

		int loccnt = loc.selectLocationChk(loccode);

		logger.debug("loccnt    값 : {}", loccnt);

		Map<String, Object> map = new HashMap();
		map.put("loccnt", loccnt);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectLocStatusList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLocStatusList(@RequestParam Map<String, Object> params) {
		List<EgovMap> statusList = loc.selectLocStatusList(params);
		return ResponseEntity.ok(statusList);
	}



}
