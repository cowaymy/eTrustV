package com.coway.trust.web.sales.pos;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/pos")
public class PosController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PosController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	//TODO 추후 삭제 (임시 Session 생성)
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@Resource(name = "posService")
	private PosService posService;
	
	@RequestMapping(value = "/selectPosList.do")
	public String selectPosList(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		LOGGER.info("###### Post List Start ###########");
		
		//TODO 추후 삭제 (임시 Session)
		params.put("userId", "KRHQ9001");
		params.put("password", "zaq12w");
		LoginVO loginVO = loginService.getLoginInfo(params);
		HttpSession session = sessionHandler.getCurrentSession();
		session.setAttribute(AppConstants.SESSION_INFO,SessionVO.create(loginVO));
		LOGGER.info("########### Session Created !!! @@@@@@@@@@@@@");
		// Session 임시 생성 끝
		
		// Session 가져오기 TEST
		/*if(session.getAttribute(AppConstants.SESSION_INFO) != null){
			
			SessionVO sessionVO = (SessionVO)session.getAttribute(AppConstants.SESSION_INFO);
			LOGGER.info("Session User Id : " + sessionVO.getUserId());
			
		}else{
			LOGGER.info(" %%%%%%%%%% Session Create Failed!!!!!  %%%%%%%%%%");
		}*/
		
		return "sales/pos/posList";
	}
	
	
	@RequestMapping(value = "/selectWhList.do")
	public ResponseEntity<List<EgovMap>> selectWhList() throws Exception{
		
		LOGGER.info("###### selectWhList Start(combo Box) ###########");
		
		List<EgovMap> codeList = posService.selectWhList();
		
		return ResponseEntity.ok(codeList);
		
	}
	
	
	@RequestMapping(value = "/selectPosJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPosJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception {
		
		List<EgovMap> posList = null;
		LOGGER.info("^^^^^^^^^^^^^^^^^^  posWhId TEST  : ^^^^^^^^^^^^^^^^ {}" , params.get("posWhId") );
		
		LOGGER.info("##### customerList START #####");
		posList = posService.selectPosJsonList(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(posList);
	}
	
	
	@RequestMapping(value = "/selectPosViewDetail.do")
	public String selectPosViewDetail(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.info("############### POS Detail Start #####################");
		EgovMap purchaseMap = posService.selectPosViewPurchaseInfo(params); // Master
		
		//Add Attribute
		model.addAttribute("purchaseMap", purchaseMap); 
		
		return "sales/pos/posViewDetail";
	}
	
	@RequestMapping(value = "/selectPosDetailJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPosDetailJsonList (@RequestParam Map<String, Object> params) throws Exception{
		
		LOGGER.info("############### selectPosDetailJsonList Start #####################");
		List<EgovMap>  detailList = null;
		detailList = posService.selectPosDetailJsonList(params);
		
		return ResponseEntity.ok(detailList);
	}
	
	
	
	@RequestMapping(value = "/selectPosPaymentJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPosPaymentJsonList (@RequestParam Map<String, Object> params) throws Exception{
		
		LOGGER.info("############### selectPosPaymentJsonList Start #####################");
		List<EgovMap>  paymentlList = null;
		paymentlList = posService.selectPosPaymentJsonList(params);
		
		return ResponseEntity.ok(paymentlList);
	}
	
	/**
	 *  Pos System Start
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertPosSystem.do") 
	public String insertPosSystem (@RequestParam Map<String, Object> params , ModelMap model) throws Exception{
		
		LOGGER.info("############### Go insertPosSystem #####################");
		
		
		//TODO 추후 삭제 (임시 Session)
		params.put("userId", "KRHQ9001");
		params.put("password", "zaq12w");
		LoginVO loginVO = loginService.getLoginInfo(params);
		HttpSession session = sessionHandler.getCurrentSession();
		session.setAttribute(AppConstants.SESSION_INFO,SessionVO.create(loginVO));
		LOGGER.info("########### Session Created !!! @@@@@@@@@@@@@");
		
		
		return "sales/pos/posSystem";
		
	}
	
	
	@RequestMapping(value = "/selectPosSalesTypeJsonList")
	public ResponseEntity<List<EgovMap>> selectPosSalesTypeJsonList (@RequestParam Map<String, Object> params, HttpSession session) throws Exception{
		
		// 세션에서 가져온 userId를 이용해서 ModuleUnit Id List 검색
		session = sessionHandler.getCurrentSession();
		
		SessionVO sessionVO = null;
		sessionVO = (SessionVO)session.getAttribute(AppConstants.SESSION_INFO);
		
		LOGGER.info("#################### USERID TEST :  {}" , sessionVO.getUserId() );
		
		params.put("userId", sessionVO.getUserId());
		List<EgovMap> userInfoList = posService.selectPosUserInfo(params); // Module Unit List 가지고있음
		
		return ResponseEntity.ok(userInfoList);
	}
	
	
	@RequestMapping(value = "/selectPosUserWarehoseIdJson")
	public ResponseEntity<EgovMap> selectPosUserWarehoseIdJson (@RequestParam Map<String, Object> params, HttpSession session) throws Exception{
		
		session = sessionHandler.getCurrentSession();
		SessionVO sessionVO = null;
		sessionVO = (SessionVO)session.getAttribute(AppConstants.SESSION_INFO);
		
		params.put("userId", sessionVO.getUserId());
		
		EgovMap userWhIdVO = posService.selectPosUserWarehoseIdJson(params);
		
		return ResponseEntity.ok(userWhIdVO);
	}
	
	
	@RequestMapping(value = "/selectPosReasonJsonList")
	public ResponseEntity<List<EgovMap>> selectPosReasonJsonList() throws Exception{
		
		List<EgovMap> reasonList = null;
		
		reasonList = posService.selectPosReasonJsonList();
		
		return ResponseEntity.ok(reasonList);
	}
 	
}
