/**
 * @author leo-HAM
 */
package com.coway.trust.web.logistics.replenishment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
import com.coway.trust.biz.logistics.replenishment.SROService;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/sro")
public class SROController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	@Value("${app.name}")
	private String appName;

	@Resource(name = "SROService")
	private SROService srosver;


	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;


	@RequestMapping(value = "/sroItemMgmt.do")
	public String sroItemMgmt(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/sro/sroItemMgmt";
	}


	@RequestMapping(value = "/sroMgmt.do")
	public String sroMgmtList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/sro/sroMgmtList";
	}


	@RequestMapping(value = "/sroItemMgmtList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  searchList(@RequestParam Map<String, Object>params, HttpServletRequest request,SessionVO sessionVO, ModelMap model) throws Exception {

		logger.debug(":: {}", params);

		String[] loctypes = request.getParameterValues("loctype");
		String[] cTypes = request.getParameterValues("cType");
		String[] catetypes = request.getParameterValues("catetype");

		if(loctypes      != null && !CommonUtils.containsEmpty(loctypes))      params.put("loctypes", loctypes);
		if(cTypes    	!= null && !CommonUtils.containsEmpty(cTypes))        params.put("cTypes", cTypes);
		if(catetypes    != null && !CommonUtils.containsEmpty(catetypes))    params.put("catetypes", catetypes);

    	List<EgovMap> list = srosver.sroItemMgntList(params);

    	logger.debug(list.toString());

		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/selectSroCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSroCodeList(@RequestParam Map<String, Object> params) {


		List<EgovMap> codeList = srosver.selectSroCodeList(params);
		return ResponseEntity.ok(codeList);
	}




	@RequestMapping(value = "/saveSroItemMgmt.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSroItemMgnt(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model) {
		logger.debug(":: {}", params);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

//		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 				// Get grid addList
//		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
//		List<Object> deleteList = params.get(AppConstants.AUIGRID_REMOVE);  	// Get grid DeleteList
//
//		logger.debug("::addList  {}", addList);
//		logger.debug("::updateList  {}", updateList);
//		logger.debug("::deleteList  {}", deleteList);

		srosver.saveSroItemMgnt(params, sessionVO);


		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		return ResponseEntity.ok(message);
	}




	@RequestMapping(value = "/saveSroMgmt.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  saveSroMgmt(@RequestParam Map<String, Object>params, HttpServletRequest request,SessionVO sessionVO, ModelMap model) throws Exception {

		logger.debug(":: {}", params);

		String reqNo =srosver.saveSroMgmt(params,sessionVO);





		logger.debug("reqNo !!!!! : {}", reqNo);
		ReturnMessage message = new ReturnMessage();

		if (reqNo != null && !"".equals(reqNo)){
		// 결과 만들기 예.
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		message.setData(reqNo);
		return ResponseEntity.ok(message);
	}




	@RequestMapping(value = "/deleteSroMgmt.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>  deleteSroMgmt(@RequestBody Map<String, Object>params, HttpServletRequest request,SessionVO sessionVO, ModelMap model) throws Exception {

		logger.debug(":: {}", params.toString());

	    List<EgovMap> remove = (List<EgovMap>) params.get("remove");

		logger.debug(":: {}", remove.toString());

		srosver.deleteUpdateLOG0112D(remove,sessionVO);



//
//
//		logger.debug("reqNo!!!!! : {}", reqNo);

		ReturnMessage message = new ReturnMessage();
//
//		if (reqNo != null && !"".equals(reqNo)){
//		// 결과 만들기 예.
//		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//		}else{
//			message.setCode(AppConstants.FAIL);
//			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
//		}
//		message.setData(reqNo);
		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/sroMgmtList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  sroMgmtList(@RequestParam Map<String, Object>params, HttpServletRequest request,SessionVO sessionVO, ModelMap model) throws Exception {

		logger.debug(":: {}", params);

		List<EgovMap> list = srosver.sroMgmtList(params);

		List<EgovMap>  rList = new ArrayList<EgovMap> ();

		if(null !=list){
			if(list.size() >0){
				for (Object  m : list){

					Map<String, Object> map = (Map<String, Object>) m;


        			if(map.get("srono").equals(map.get("srorefsrono"))){

        				//tree를 만들려면  srorefsrono가 json에 없어야 한다.

        				EgovMap  newMap = new EgovMap();
        				newMap.put("rowno", map.get("rowno"));
        				newMap.put("srono", map.get("srono"));
        				newMap.put("srocrtdt", map.get("srocrtdt"));
        				newMap.put("srofrwlcd", map.get("srofrwlcd"));
        				newMap.put("srofrwldesc", map.get("srofrwldesc"));
        				newMap.put("srotowlcd", map.get("srotowlcd"));
        				newMap.put("srotowldesc", map.get("srotowldesc"));
        				newMap.put("sroreqno", map.get("sroreqno"));
        				newMap.put("srostacd", map.get("srostacd"));
        				newMap.put("sromatdocno", map.get("sromatdocno"));
        				newMap.put("sromsg", map.get("sromsg"));
        				newMap.put("crtdt", map.get("crtdt"));
        				newMap.put("osrono", map.get("osrono"));
        				newMap.put("srotype", map.get("srotype"));
        				newMap.put("reqstus", map.get("reqstus"));
        				newMap.put("reqstdelyn", map.get("reqstdelyn"));


        				rList.add(newMap);


        			}else{
        				rList.add((EgovMap)map);
        			}
        		}
			}
		}


    	logger.debug(rList.toString());

		return ResponseEntity.ok(rList);
	}


	@RequestMapping(value = "/sroMgmtDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  sroMgmtDetailList(@RequestParam Map<String, Object>params, HttpServletRequest request,SessionVO sessionVO, ModelMap model) throws Exception {

		logger.debug(":: {}", params);
		List<EgovMap> list = srosver.sroMgmtDetailList(params);

    	return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/sroMgmtDetailListPopUp.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  sroMgmtDetailListPopUp(@RequestParam Map<String, Object>params, HttpServletRequest request,SessionVO sessionVO, ModelMap model) throws Exception {

		logger.debug(":: {}", params);
		List<EgovMap> list = srosver.sroMgmtDetailListPopUp(params);

    	return ResponseEntity.ok(list);
	}



}
