package com.coway.trust.web.logistics.serialHistory;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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

import com.coway.trust.biz.logistics.serialHistory.SerialHistoryService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialNoHistoryController.java
 * @Description : SerialNoHistoryController
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 21.   KR-HAN        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/logistics/serialHistory")
public class SerialNoHistoryController {

	private static final Logger logger = LoggerFactory.getLogger(SerialNoHistoryController.class);

	@Resource(name = "serialHistoryService")
	private SerialHistoryService serialHistoryService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	 /**
	 * 시리일 팝업 호출
	 * @Author KR-HAN
	 * @Date 2019. 12. 21.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/serialNoHistoryPop.do")
	public String serialNoHistoryPop(@RequestParam Map<String, Object>params, ModelMap model){

		logger.debug("params ======================================>>> " + params);

	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
        String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

        model.put("bfDay", bfDay);
        model.put("toDay", toDay);
        model.put("ordNo", params.get("ordNo"));
        model.put("refDocNo", params.get("refDocNo"));

		return "logistics/serialHistory/serialNoHistoryPop";
	}

	 /**
	 * 시리얼 이력 조회
	 * @Author KR-HAN
	 * @Date 2019. 12. 21.
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/selectSerialHistoryList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSerialHistoryList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> serialHistoryList = null;
		serialHistoryList = serialHistoryService.selectSerialHistoryList(params);

		return ResponseEntity.ok(serialHistoryList);
	}
}