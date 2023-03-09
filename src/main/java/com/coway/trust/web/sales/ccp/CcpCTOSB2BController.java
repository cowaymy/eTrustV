package com.coway.trust.web.sales.ccp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.coway.trust.biz.sales.ccp.CcpCTOSB2BService;
import com.coway.trust.biz.sales.ccp.CcpExpB2BService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpCTOSB2BController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCTOSB2BController.class);

	@Resource(name = "ccpCTOSB2BService")
	private CcpCTOSB2BService ccpCTOSB2BService;

//experian
	@Resource(name = "ccpExpB2BService")
    private CcpExpB2BService ccpExpB2BService;
//experian

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;


	@RequestMapping(value = "/selectB2BList.do")
	public String selectB2BList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.info("################ Start B2BList #########");
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "sales/ccp/ccpCTOSB2BList";

	}

	@RequestMapping(value = "/selectCTOSB2BList")
	public ResponseEntity<List<EgovMap>> selectCTOSB2BList(@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{


		LOGGER.info("######################  get CTOS List ###################");
		List<EgovMap> ctosList = null;
		String stusArr[] = request.getParameterValues("stus");
		params.put("stusArr", stusArr);
		ctosList = ccpCTOSB2BService.selectCTOSB2BList(params);

		return ResponseEntity.ok(ctosList);
	}


	@RequestMapping(value = "/getCTOSDetailList")
	public ResponseEntity<List<EgovMap>> getCTOSDetailList (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("######################  get CTOS Detail List ###################");
		List<EgovMap> detailList = null;
		detailList = ccpCTOSB2BService.getCTOSDetailList(params);

		return ResponseEntity.ok(detailList);

	}


	@RequestMapping(value = "/getCTOSDetailByOrdNo")
	public ResponseEntity<List<EgovMap>> getCTOSDetailByOrdNo (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.info("######################  get CTOS Detail List ###################");
		List<EgovMap> detailList = null;
		detailList = ccpCTOSB2BService.getCTOSDetailList(params);

		return ResponseEntity.ok(detailList);

	}

	@RequestMapping(value = "/getResultRowForCTOSDisplay")
	public ResponseEntity<Map<String, Object>> getResultRowForCTOSDisplay(@RequestParam Map<String, Object> params) throws Exception{

		 Map<String, Object> rtnMap =	ccpCTOSB2BService.getResultRowForCTOSDisplay(params);

		LOGGER.info("####################ResultRow Chk RESULT : " + rtnMap.toString());
		return ResponseEntity.ok(rtnMap);
	}

	@RequestMapping(value = "/selectB2BListConfig.do")
	public String selectB2BListConfig(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{



		return "sales/ccp/ccpCTOSB2BConfig";

	}

	  @RequestMapping(value = "/savePromoB2BUpdate.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> saveVRescueUpdate(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		  LOGGER.debug("params :"+ params.toString());
		  params.put("userId", sessionVO.getUserId());



		  ccpCTOSB2BService.savePromoB2BUpdate(params);

		  ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setData("");
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


			return ResponseEntity.ok(message);

		}

	//experian
	   @RequestMapping(value = "/selectExpB2BList.do")
	    public String selectExpB2BList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

	        LOGGER.info("################ Start B2BList #########");
	        String expbfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
	        String exptoDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	        model.put("bfDay", expbfDay);
	        model.put("toDay", exptoDay);

	        return "sales/ccp/ccpExpB2BList";
	    }
	    @RequestMapping(value = "/selectEXPERIANB2BList")
	    public ResponseEntity<List<EgovMap>> selectEXPERIANB2BList(@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{

	        LOGGER.info("######################  get EXPERIAN List ###################");
	        List<EgovMap> expList = null;
	        String stusExpArr[] = request.getParameterValues("stus");
	        params.put("stusArr", stusExpArr);
	        expList = ccpExpB2BService.selectEXPERIANB2BList(params);

	        return ResponseEntity.ok(expList);
	    }


	    @RequestMapping(value = "/getExpDetailList")
	    public ResponseEntity<List<EgovMap>> getExpDetailList (@RequestParam Map<String, Object> params) throws Exception{

	        LOGGER.info("######################  get EXPERIAN Detail List ###################");
	        List<EgovMap> expdetailList = null;
	        expdetailList = ccpExpB2BService.getExpDetailList(params);

	        return ResponseEntity.ok(expdetailList);
	    }

	    @RequestMapping(value = "/getExpDetailByOrdNo")
	    public ResponseEntity<List<EgovMap>> getExpDetailByOrdNo (@RequestParam Map<String, Object> params) throws Exception{

	        LOGGER.info("######################  get EXPERIAN Detail List ###################");
	        List<EgovMap> expdetailList = null;
	        expdetailList = ccpExpB2BService.getExpDetailList(params);

	        return ResponseEntity.ok(expdetailList);
	    }

	    @RequestMapping(value = "/getResultRowForExpDisplay")
	    public ResponseEntity<Map<String, Object>> getResultRowForExpDisplay(@RequestParam Map<String, Object> params) throws Exception{

	         Map<String, Object> rtnexpMap =   ccpExpB2BService.getResultRowForExpDisplay(params);

	        LOGGER.info("####################ResultRow Chk RESULT : " + rtnexpMap.toString());
	        return ResponseEntity.ok(rtnexpMap);
	    }
	//experian

		@RequestMapping(value = "/reuploadCTOSB2BList.do", method = RequestMethod.GET)
		public ResponseEntity<ReturnMessage> reuploadCTOSB2BList (SessionVO sessionVO) throws Exception{

			LOGGER.info("######################  Reupload CTOS B2B List ###################");

		    Map<String, Object> resltCode = new HashMap<String, Object>();
		    Map<String, Object> returnMap = new HashMap<String, Object>();

			ReturnMessage mes = new ReturnMessage();
			String message = "";


			ccpCTOSB2BService.reuploadCTOSB2BList(resltCode, sessionVO);
			int rslt = 0;
		    rslt = (int) resltCode.get("p1");

		    if(rslt == -1){
					message = "<b>Failed to reupload.<br />Please try again later.</b>";
		    } else {
					message = "<b>Successfully Reupload</b>";
		    }

			mes.setCode(AppConstants.SUCCESS);
			mes.setMessage(message);

			return ResponseEntity.ok(mes);
		}

		@RequestMapping(value = "/ccpSwitchTower.do")
    public String ccpSwitchTower(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		  EgovMap currentTower = ccpCTOSB2BService.getCurrentTower(params);
		  model.put("currentTower", currentTower);

		  EgovMap currentAgeGroup = ccpCTOSB2BService.getCurrentAgeGroup(params);
		  model.put("currentAgeGroup", currentAgeGroup);

		  System.out.println(model);
        return "sales/ccp/ccpSwitchTower";
    }

    @RequestMapping(value = "/updateCurrentTower.do")
    public ResponseEntity<ReturnMessage> updateCurrentTower(@RequestParam Map<String, Object> params, SessionVO sessionVO) throws Exception{

      System.out.println(params);

      params.put("userId", sessionVO.getUserId());
      int result =ccpCTOSB2BService.updateCurrentTower(params);
      //int result2 = ccpCTOSB2BService.updateAgeGroup(params);

      ReturnMessage message = new ReturnMessage();

      if(result > 0){
          message.setCode(AppConstants.SUCCESS);
          message.setData("");
          message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
      }
      else{
    	  message.setCode(AppConstants.FAIL);
          message.setData("");
          message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
      }



      return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/selectAgeGroupList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectAgeGroupList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        List<EgovMap> ageGroupList = ccpCTOSB2BService.selectAgeGroupList(params);

        return ResponseEntity.ok(ageGroupList);
     }


}
