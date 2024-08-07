package com.coway.trust.web.logistics.hsfilter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.hsfilter.HsFilterDeliveryService;
import com.coway.trust.biz.logistics.hsfilter.HsFilterLooseService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/HsFilterLoose")

public class HsFilterLooseController {

  private static final Logger LOGGER = LoggerFactory.getLogger(HsFilterLooseController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Resource(name = "HsFilterLooseService")
  private HsFilterLooseService hsFilterLooseService;


  @Resource(name = "HsFilterDeliveryService")
  private HsFilterDeliveryService hsFilterDeliveryService;


  @RequestMapping(value = "/hsFilterLooseList.do")
  public String hsFilterDeliveryList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)



    return "logistics/hsfilter/hsFilterLooseList";
  }




  @RequestMapping(value = "/hsFilterLooseForMiscList.do")
  public String hsFilterLooseForMiscList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    return "logistics/hsfilter/hsFilterLooseForMiscList";
  }




  @RequestMapping(value = "/hsFilterMappingList.do")
  public String hsFilterMappingList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)



    return "logistics/hsfilter/hsFilterMappingList";
  }




	@RequestMapping(value = "/selectHSFilterForecastBranchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHSFilterForecastBranchList(@RequestParam Map<String, Object> params) {

		List<EgovMap> list = hsFilterDeliveryService.selectHSFilterDeliveryBranchList(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectMappingLocationType.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMappingLocationType(@RequestParam Map<String, Object> params) {

		List<EgovMap> list = hsFilterLooseService.selectMappingLocationType(params);
		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/selectMappingCdbLocationList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMappingCdbLocationList(@RequestParam Map<String, Object> params) {



		String searchgb = (String) params.get("searchlocgb");
		String[] searchgbvalue = searchgb.split("∈");
		//Map<String, Object> smap = new HashMap();
		params.put("searchlocgb", searchgbvalue);


		List<EgovMap> list = hsFilterLooseService.selectMappingCdbLocationList(params);
		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/selectMiscBranchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMiscBranchList(@RequestParam Map<String, Object> params) {

		List<EgovMap> list = hsFilterLooseService.selectMiscBranchList(params);
		return ResponseEntity.ok(list);
	}




	@RequestMapping(value = "/selectHSFilterLooseList.do" , method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHSFilterDeliveryList(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		String[] cate = request.getParameterValues("cmbCategory");
		String[] type = request.getParameterValues("cmbType");

		String stkNm = request.getParameter("stkNm");
		String stkCd = request.getParameter("stkCd");

		Map<String, Object> smap = new HashMap();
		smap.put("cateList", cate);
		smap.put("typeList", type);
		smap.put("stkNm", stkNm);
		smap.put("stkCd", stkCd);

		List<EgovMap> list = hsFilterLooseService.selectHSFilterLooseList(smap);


		return ResponseEntity.ok(list);
	}




	@RequestMapping(value = "/selectHSFilterLooseForMiscList.do" , method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHSFilterLooseForMiscList(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		String[] cate = request.getParameterValues("cmbCategory");
		String[] type = request.getParameterValues("cmbType");
		String[] cdbList = request.getParameterValues("cdbType");

		String stkNm = request.getParameter("stkNm");
		String stkCd = request.getParameter("stkCd");

		Map<String, Object> smap = new HashMap();
		smap.put("cateList", cate);
		smap.put("typeList", type);
		smap.put("cdbList", cdbList);
		smap.put("stkNm", stkNm);
		smap.put("stkCd", stkCd);

		List<EgovMap> list = hsFilterLooseService.selectHSFilterLooseMiscList(smap);


		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/selectHSFilterMappingList.do" , method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHSFilterMappingList(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		String[] searchLocList = request.getParameterValues("searchLoc");
		String[] searchCtgryList = request.getParameterValues("searchCtgry");
		String[] searchTypeList = request.getParameterValues("searchType");


		String searchMatCode = request.getParameter("searchMatCode");
		String searchMatName = request.getParameter("searchMatName");
		String searchBranch    = request.getParameter("searchBranch");
		String searchCDC       = request.getParameter("searchCDC");


		Map<String, Object> smap = new HashMap();
		smap.put("searchLocList", searchLocList);
		smap.put("searchCtgryList", searchCtgryList);
		smap.put("searchTypeList", searchTypeList);

		smap.put("searchMatCode", searchMatCode);
		smap.put("searchMatName", searchMatName);
		smap.put("searchCDC", searchCDC);
		smap.put("searchBranch", searchBranch);



		if(request.getParameter("forecastMonth") !="" || request.getParameter("forecastMonth") !=null ){

			String date[] = (String[])(request.getParameter("forecastMonth")).toString().split("/");


			smap.put("searchMM", date[0]);
			smap.put("searchYYYY", date[1]);
		}


		List<EgovMap> list = hsFilterLooseService.selectHSFilterMappingList(smap);


		return ResponseEntity.ok(list);
	}








	  @RequestMapping(value = "/insertHSFilterLooseList.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> insertPos(@RequestBody Map<String, Object> params) throws Exception {
	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	    params.put("userId", sessionVO.getUserId());

	    LOGGER.debug(params.toString());



//		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 				// Get grid addList
//		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
//		List<Object> deleteList = params.get(AppConstants.AUIGRID_REMOVE);  	// Get grid DeleteL


	     hsFilterLooseService.updateMergeLOG0107M(params);


	    // Return MSG
	    ReturnMessage message = new ReturnMessage();

	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	    return ResponseEntity.ok(message);

	  }




	  @RequestMapping(value = "/insertHSFilterLooseForMiscList.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> insertForMiscPos(@RequestBody Map<String, Object> params) throws Exception {
	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	    params.put("userId", sessionVO.getUserId());

	    LOGGER.debug(params.toString());



//		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 				// Get grid addList
//		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
//		List<Object> deleteList = params.get(AppConstants.AUIGRID_REMOVE);  	// Get grid DeleteL


	     hsFilterLooseService.updateMergeLOG0109M(params);


	    // Return MSG
	    ReturnMessage message = new ReturnMessage();

	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	    return ResponseEntity.ok(message);

	  }


}
