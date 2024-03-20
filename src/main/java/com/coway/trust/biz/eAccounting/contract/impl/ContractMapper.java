package com.coway.trust.biz.eAccounting.contract.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("contractMapper")
public interface ContractMapper {

	List<EgovMap> selectContractTrackingList(Map<String, Object> params);

	int selectNextContractId();

	String selectNextContractNo();

	void insertVendorMain(Map<String, Object> params);

	void insertVendorDetails(Map<String, Object> params);

	int selectNextContractSeq(int contTrackId);

	void insertContractCycleDetails(Map<String, Object> params);

	EgovMap selectContractTrackingViewDetails(Map<String, Object> params);

	List<EgovMap> selectContractCycleDetails(Map<String, Object> params);

	void updateContractCycleDetails(Map<String, Object> params);

	void removeContractCycleDetails(Map<String, Object> params);

	void updateRenewalCycle(Map<String, Object> params);

}
