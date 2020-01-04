package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.servicePlanning.MagicAddressService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MagicAddressServiceImpl.java
 * @Description : Magic Address ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 3.   KR-SH        First creation
 * </pre>
 */
@Service("magicAddressService")
public class MagicAddressServiceImpl  extends EgovAbstractServiceImpl implements MagicAddressService{

	@Resource(name = "magicAddressMapper")
	private MagicAddressMapper magicAddressMapper;

	/**
	 * Search Magic Address
	 * @Author KR-SH
	 * @Date 2019. 12. 3.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.services.servicePlanning.CTSubGroupListService#selectCTSubGroupList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectMagicAddress(Map<String, Object> params) {
		return magicAddressMapper.selectMagicAddress(params);
	}

}
