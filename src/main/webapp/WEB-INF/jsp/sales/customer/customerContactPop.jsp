<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<section class="pop_body"><!-- pop_body start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:145px" />
        <col style="width:*" />
        <col style="width:115px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Status</th>
        <td><span>${detailcontact.name}</span></td>
        <th scope="row">Create By</th>
        <td><span><c:if test="${not empty detailcontact.crtDt}">(${detailcontact.crtDt})</c:if></span></td>
    </tr>
    <tr>
        <th scope="row">Initial</th>
        <td><c:if test="${detailcontact.custInitial ne 0}">${detailcontact.custInitial}</c:if></td>
        <th scope="row">Update By</th>
        <td>${detailcontact.userName1}<c:if test="${not empty detailcontact.updDt}">(${detailcontact.updDt})</c:if></td>
    </tr>
    <tr>
        <th scope="row">Name</th>
        <td>${detailcontact.name1}</td>
        <th scope="row">NRIC</th>
        <td>${detailcontact.nric}</td>
    </tr>
    <tr>
        <th scope="row">DOB</th>
        <td><c:if test="${detailcontact.dob ne '01-01-1900'}">${detailcontact.dob}</c:if></td>
        <th scope="row">Gender</th>
        <td>
            <c:if test="${detailcontact.gender eq 'F'}">
                Female
            </c:if>
            <c:if test="${detailcontact.gender eq 'M'}">
                Male
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row">Race</th>
        <td>${detailcontact.codeName}</td>
        <th scope="row">Email</th>
        <td>${detailcontact.email}</td>
    </tr>
    <tr>
        <th scope="row">Tel (Mobile)</th>
        <td>${detailcontact.telM1}</td>
        <th scope="row">Tel (Office)</th>
        <td>${detailcontact.telO }</td>
    </tr>
    <tr>
        <th scope="row">Tel (Residence)</th>
        <td>${detailcontact.telR }</td>
        <th scope="row">Tel (Fax)</th>
        <td>${detailcontact.telf}</td>
    </tr>
    <tr>
        <th scope="row">Department</th>
        <td>${detailcontact.dept}</td>
        <th scope="row">Post</th>
        <td>${detailcontact.pos}</td>
    </tr>
    </tbody>
    </table><!-- table end -->

</section><!-- pop_body end -->