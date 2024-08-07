package com.coway.trust.biz.services.installation;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface InstallationApplication {

	void insertInstallationAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs);

	void updateInstallationAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs);

}
