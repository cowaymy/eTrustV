package com.coway.trust.biz.eAccounting.scmActivityFund;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface ScmActivityFundApplication {
	
	void insertScmActivityFundAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updateScmActivityFundAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void deleteScmActivityFundAttachBiz(FileType type, Map<String, Object> params);

}
