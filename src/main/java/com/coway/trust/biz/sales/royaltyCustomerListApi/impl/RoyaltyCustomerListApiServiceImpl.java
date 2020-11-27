package com.coway.trust.biz.sales.royaltyCustomerListApi.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.royaltyCustomerListApi.RoyaltyCustomerListApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ProductInfoListApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("ProductInfoListApiService")
public class RoyaltyCustomerListApiServiceImpl extends EgovAbstractServiceImpl implements RoyaltyCustomerListApiService{



	@Resource(name = "RoyaltyCustomerListApiMapper")
	private RoyaltyCustomerListApiMapper royaltyCustomerListApiMapper;

    @Override
	public List<EgovMap> selectWsLoyaltyList() throws Exception {
		// TODO Auto-generated method stub
		return royaltyCustomerListApiMapper.selectWsLoyaltyList();
	}

}
