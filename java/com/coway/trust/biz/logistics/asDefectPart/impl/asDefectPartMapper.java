/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.asDefectPart.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("AsDefectPartMapper")
public interface asDefectPartMapper
{
	List<EgovMap> searchAsDefPartList(Map<String, Object> params); // Referral Info

	EgovMap selectAsDefectPartInfo(Map<String, Object> params);

	void addDefPart(Map<String, Object> params);

	void updateDefPart(Map<String, Object> params);

	void updateDefPartStus(Map<String, Object> params);

	EgovMap getStkInfo(Map<String, Object> params);

	List<EgovMap> checkDefPart(Map<String, Object> params);

	List<EgovMap> chkDupLinkage(Map<String, Object> params);
}
