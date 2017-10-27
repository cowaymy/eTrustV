/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipRentalStatusService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author kmo
 *
 */
@Service("membershipRentalStatusService")
public class MembershipRentalStatusServiceImpl extends EgovAbstractServiceImpl implements MembershipRentalStatusService {

//	private static Logger logger = LoggerFactory.getLogger(OrderListServiceImpl.class);
	
	@Resource(name = "membershipRentalStatusMapper")
	private MembershipRentalStatusMapper membershipRentalStatusMapper;
	
	//@Autowired
	//private MessageSourceAccessor messageSourceAccessor;  
	
	@Override
	public List<EgovMap> selectCnvrList(Map<String, Object> params) {
		return membershipRentalStatusMapper.selectCnvrList(params);
	}

	@Override
	public List<EgovMap> selectCnvrDetailList(Map<String, Object> params) {
		return membershipRentalStatusMapper.selectCnvrDetailList(params);
	}

	@Override
	public EgovMap selectCnvrDetail(Map<String, Object> params) {
		return membershipRentalStatusMapper.selectCnvrDetail(params);
	}
	
	@Override
	public int selectCnvrDetailCount(Map<String, Object> params) {
		return membershipRentalStatusMapper.selectCnvrDetailCount(params);
	}
}
