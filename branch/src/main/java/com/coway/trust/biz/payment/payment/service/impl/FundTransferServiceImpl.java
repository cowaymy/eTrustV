package com.coway.trust.biz.payment.payment.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.payment.service.FundTransferService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("fundTransferService")
public class FundTransferServiceImpl extends EgovAbstractServiceImpl implements FundTransferService {

	@Resource(name = "fundTransferMapper")
	private FundTransferMapper fundTransferMapper;
	

	 /**
	 * Fund Transfer Item List 조회
	 * 
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectFundTransferItemList(Map<String, Object> params){
		return fundTransferMapper.selectFundTransferItemList(params);
	}
	
	
	
}
