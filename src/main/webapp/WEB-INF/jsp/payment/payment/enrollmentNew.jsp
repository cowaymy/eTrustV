<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
</script>

<!-- <div id="popup_wrap" style="display:none;"> -->
<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>Enrollment Result Update</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#" onclick="$('#popup_wrap').hide();"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
    </header>
    
    <section class="pop_body"><!-- pop_body start -->
    
    <form name="myForm" id="myForm">
    <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:175px" />
            <col style="width:330px" />
            <col style="width:100px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">Update Type</th>
                <td colspan="3">
                    <select name="updateType" style="width:100%">
                        <option value="978">Submit Date</option>
                        <option value="979">Start Date</option>
                        <option value="980">Reject Date</option>
                    </select>
                </td>
            </tr>
             <tr>
                <th scope="row">Select your CSV file *</th>
                <td>
                    <div class="auto_file"><!-- auto_file start -->
                        <input type="file" id="fileSelector" title="file add" accept=".csv"/>
                    </div><!-- auto_file end -->
                </td>
                <td>
                    <a href="javascript:fn_saveGridMap();"><img src="${pageContext.request.contextPath}/resources/images/common/btn.gif" alt="Read CSV" /></a>
                </td>
                <td>
                    <a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/btn.gif" alt="Download CSV Format" /></a>
                </td>
            </tr>
        </tbody>
    </table>
    </form>
    <!-- grid_wrap start -->
    <article id="grid_wrap_view" class="grid_wrap"></article>
    <!-- grid_wrap end -->
</section><!-- pop_body end -->
</div>