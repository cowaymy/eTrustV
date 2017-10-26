package com.coway.trust.web.sales.pos;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.coway.trust.config.handler.SessionHandler;

@Controller
@RequestMapping(value = "/sales/pos")
public class PosOthController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PosOthController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	/*@Resource(name = "posService")
	private PosService posService;*/
	
	/*@RequestMapping(value = "/selectPosList.do")
	public String selectPosList(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		LOGGER.info("###### Post List Start ###########");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		//TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)
		
		return "sales/pos/posList";
	}*/
}
