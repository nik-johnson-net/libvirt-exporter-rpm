Name:           libvirt-exporter
Version:        1.0.0
Release:        1%{?dist}
Summary:        Prometheus exporter for libvirt statistics.

License:        MIT
URL:            https://github.com/AlexZzz/libvirt-exporter
Source0:        https://github.com/AlexZzz/libvirt-exporter/archive/%{version}/%{name}-%{version}.tar.gz
Source1:        https://github.com/nik-johnson-net/%{name}-rpm/archive/%{version}/%{name}-rpm-%{version}.tar.gz

BuildRequires:  golang libvirt-devel
Requires:       libvirt

%global _missing_build_ids_terminate_build 0
%global debug_package %{nil}

%description
Prometheus exporter for libvirt statistics.

%prep
%setup -q -a 1

%build
go build -o %{name}

%pre
getent passwd libvirt-exporter >/dev/null || useradd -r -g nobody -G libvirt -M -d /nonexisting -s /sbin/nologin libvirt-exporter
exit 0

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}/%{_bindir}
mkdir -p %{buildroot}/%{_unitdir}

install -m 0755 %{name} %{buildroot}/%{_bindir}/
install -m 0644 %{name}-rpm-%{version}/systemd/%{name}.service %{buildroot}/%{_unitdir}/%{name}.service

%files
%{_bindir}/%{name}
%{_unitdir}/%{name}.service

%changelog
* Wed Sep 16 2020 Nik Johnson <nik@nikjohnson.net>
- Init