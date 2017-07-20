package com.coway.trust.biz.payment.payment.service;

import java.util.List;

public interface RentalCollectionByBSService
{

	
	/**
	 * RentalCollectionByBS 조회
	 * @param params
	 * @return
	 */
    List<RentalCollectionByBSSearchVO> searchRentalCollectionByBSList(RentalCollectionByBSSearchVO searchVO);

}
