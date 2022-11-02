/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.asDefectPart;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface asDefectPartService
{
	List<EgovMap> searchAsDefPartList(Map<String, Object> params);

	EgovMap selectAsDefectPartInfo(Map<String, Object> params);

	void addDefPart(Map<String, Object> params);

	void updateDefPart(Map<String, Object> params);

	void updateDefPartStus(Map<String, Object> params);

	EgovMap getStkInfo(Map<String, Object> params);

	List<EgovMap> checkDefPart(Map<String, Object> params);

	List<EgovMap> chkDupLinkage(Map<String, Object> params);
}
