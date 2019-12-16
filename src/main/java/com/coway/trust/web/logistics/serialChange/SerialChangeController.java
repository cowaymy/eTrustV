
package com.coway.trust.web.logistics.serialChange;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.logistics.serialChange.SerialChangeService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

/**
 * @ClassName : SerialChangeController.java
 * @Description : 시리얼 변경 Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 13.   KR-HAN        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/logistics/serialChange")
public class SerialChangeController {

	private static Logger logger = LoggerFactory.getLogger(SerialChangeController.class);

	@Resource(name = "serialChangeService")
	private SerialChangeService serialChangeService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	// KR_HAN
	// 시러얼 수정 팝업 호출
	@RequestMapping(value="/serialNoChangePop.do")
	public String serialNoChangePop(@RequestParam Map<String, Object> params, ModelMap model){

		logger.debug("serialNoModificationPop params : {}",params);

		model.put("pSerialNo"		, params.get("pSerialNo") );
		model.put("pSalesOrdId"	, params.get("pSalesOrdId") );
		model.put("pSalesOrdNo"	, params.get("pSalesOrdNo") );
		model.put("pRefDocNo"		, params.get("pRefDocNo") );
		model.put("pItmCode"		, params.get("pItmCode") );
		model.put("pCallGbn"			, params.get("pCallGbn") );
		model.put("pMobileYn"		, params.get("pMobileYn") );

		return "logistics/serialChange/serialNoChangePop";
	}


    // KR HAN : Save Serial No Modify
	@RequestMapping(value = "/saveSerialChange.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSerialNoModify(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {

		Map<String, Object> rmap = new HashMap<>();

		params.put("userId", sessionVo.getUserId());

		logger.debug("saveSerialNoModify.do :::: params {} ", params);

		rmap =  serialChangeService.saveSerialNoModify(params);

		logger.debug("++++ rmap.toString() ::" + rmap.toString() );

	    // 결과 만들기
	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setData(rmap);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

}
